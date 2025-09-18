data "aws_caller_identity" "current" {}

# General pipeline bucket
resource "aws_s3_bucket" "ml_pipeline_bucket" {
  bucket        = "ml-anomaly-pipeline-${data.aws_caller_identity.current.account_id}-${var.env}"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "ml_pipeline_bucket" {
  bucket = aws_s3_bucket.ml_pipeline_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# MLflow artifacts bucket
resource "aws_s3_bucket" "mlflow_artifacts" {
  bucket        = "mlflow-artifacts-${data.aws_caller_identity.current.account_id}-${var.env}"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "mlflow_artifacts" {
  bucket = aws_s3_bucket.mlflow_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}
