variable "region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "ml-anomaly-eks"
}

variable "ml_bucket_name" {
  description = "S3 bucket for MLflow artifacts"
  type        = string
  default     = "ml-anomaly-bucket"
}

variable "env" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}
