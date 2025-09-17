variable "region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  description = "EKS cluster name for FIS targeting"
  type        = string
  default     = "ml-anomaly-cluster"
}
