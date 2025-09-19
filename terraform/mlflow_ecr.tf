resource "aws_ecr_repository" "mlflow" {
  name                 = "mlflow"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "ml-anomaly"
    Environment = var.env
  }
}
