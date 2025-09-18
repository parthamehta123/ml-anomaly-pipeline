# Minimal IAM policy for EKS cluster access
data "aws_iam_policy_document" "eks_minimal_access" {
  statement {
    sid    = "AllowEKSClusterAccess"
    effect = "Allow"

    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
    ]

    resources = [
      "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/${var.eks_cluster_name}"
    ]
  }
}

resource "aws_iam_policy" "eks_minimal_access" {
  name        = "${var.eks_cluster_name}-minimal-access"
  description = "Minimal access policy for EKS cluster Describe/List"
  policy      = data.aws_iam_policy_document.eks_minimal_access.json
}

resource "aws_iam_role_policy_attachment" "eks_minimal_access" {
  role       = module.eks.cluster_iam_role_name
  policy_arn = aws_iam_policy.eks_minimal_access.arn
}
