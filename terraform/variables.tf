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

variable "ghcr_username" {
  type        = string
  description = "GitHub username for GHCR authentication"
}

variable "ghcr_token" {
  type        = string
  description = "GitHub personal access token with read:packages"
  sensitive   = true
}

variable "mlflow_version" {
  description = "MLflow version to deploy"
  type        = string
  default     = "2.0.1" # can override in tfvars or CLI
}
