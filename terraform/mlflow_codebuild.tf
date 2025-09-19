resource "aws_codebuild_project" "mlflow_mirror" {
  name         = "mlflow-mirror"
  service_role = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:6.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true # required for Docker
  }
  source {
    type      = "GITHUB"
    location  = "https://github.com/mlflow/mlflow"
    buildspec = file("buildspec.yml")
  }
}
