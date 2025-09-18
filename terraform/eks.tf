module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "ml-anomaly-eks"
  cluster_version = "1.29"

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      instance_types = ["t3.medium"]

      labels = {
        role = "worker"
      }
    }
  }

  tags = {
    Environment = "ml-anomaly"
    Project     = "ml-anomaly-pipeline"
  }
}
