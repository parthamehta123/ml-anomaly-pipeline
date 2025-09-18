terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Configure Kubernetes provider (uses your local kubeconfig)
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Helm will inherit Kubernetes provider automatically
provider "helm" {}

# S3 bucket for MLflow artifacts
resource "aws_s3_bucket" "ml_bucket" {
  bucket = "ml-anomaly-bucket"
}

resource "aws_s3_bucket_versioning" "ml_bucket_versioning" {
  bucket = aws_s3_bucket.ml_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
