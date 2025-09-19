# ----------------------------
# IAM Role for CodeBuild
# ----------------------------
resource "aws_iam_role" "codebuild_role" {
  name = "mlflow-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Admin for now (you can restrict later)
resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ----------------------------
# CodeBuild Project
# ----------------------------
resource "aws_codebuild_project" "mlflow_mirror" {
  name          = "mlflow-mirror"
  description   = "Mirror MLflow images from DockerHub to ECR"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = 30

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/parthamehta123/ml-anomaly-pipeline"
    buildspec       = "buildspec.yml"
    git_clone_depth = 1
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/mlflow-mirror"
      stream_name = "build"
    }
  }

  tags = {
    Project     = "ml-anomaly-pipeline"
    Environment = "dev"
  }
}
