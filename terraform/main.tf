provider "aws" { region = "us-east-1" }

resource "aws_s3_bucket" "ml_bucket" { bucket = "ml-anomaly-bucket" versioning { enabled = true } }