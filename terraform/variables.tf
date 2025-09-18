variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets for EKS worker nodes"
  type        = list(string)
}
