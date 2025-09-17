resource "aws_fis_experiment_template" "cpu_stress" {
  description = "CPU stress chaos test on EKS worker nodes"
  role_arn    = aws_iam_role.fis_role.arn

  stop_condition {
    source = "none"
  }

  target {
    name          = "eks-nodes"
    resource_type = "aws:ec2:instance"
    selection_mode = "ALL"
    resource_tags = {
      "eks:cluster-name" = var.eks_cluster_name
    }
  }

  action {
    name      = "cpu-stress"
    action_id = "aws:ssm:send-command"
    parameters = {
      documentArn = "arn:aws:ssm:${var.region}::document/AWSFIS-Run-CPU-Stress"
      duration    = "PT2M"
    }
    targets = {
      Instances = "eks-nodes"
    }
  }
}