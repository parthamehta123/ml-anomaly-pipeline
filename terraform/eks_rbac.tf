# Ensure your IAM user is registered with EKS
resource "aws_eks_access_entry" "admin_user" {
  cluster_name  = module.eks.cluster_name
  principal_arn = "arn:aws:iam::413117505590:user/admin17September2025"
  type          = "STANDARD"
}

# Attach admin-level access policy
resource "aws_eks_access_policy_association" "admin_user_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_eks_access_entry.admin_user.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
