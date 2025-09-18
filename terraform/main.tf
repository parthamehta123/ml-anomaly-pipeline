terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95, < 6.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.0"
    }
  }
}

# ----------------------------
# AWS Provider
# ----------------------------
provider "aws" {
  region = var.region
}

# ----------------------------
# VPC Module
# ----------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "ml-anomaly-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Project     = "ml-anomaly-pipeline"
    Environment = "dev"
  }
}

# ----------------------------
# Fetch your current public IP
# ----------------------------
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com/"
}

locals {
  my_cidr = "${chomp(data.http.my_ip.response_body)}/32"
}

# ----------------------------
# EKS Module
# ----------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = [local.my_cidr]

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3

      labels = {
        role = "worker"
      }
    }
  }

  tags = {
    Project     = "ml-anomaly-pipeline"
    Environment = "dev"
  }
}

# ----------------------------
# Data sources for Helm provider
# ----------------------------
data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

# ----------------------------
# Kubernetes Provider (aliased as eks)
# ----------------------------
provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

# ----------------------------
# Helm Provider (wired to EKS)
# ----------------------------
provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# ----------------------------
# S3 Bucket for MLflow
# ----------------------------
resource "aws_s3_bucket" "ml_bucket" {
  bucket = var.ml_bucket_name
}

resource "aws_s3_bucket_versioning" "ml_bucket_versioning" {
  bucket = aws_s3_bucket.ml_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
