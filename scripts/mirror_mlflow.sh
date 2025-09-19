#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="us-east-1"
MLFLOW_VERSION="2.0.1"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/mlflow"

echo "🔹 Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

echo "🔹 Pulling MLflow image from Docker Hub..."
docker pull mlflow/mlflow:${MLFLOW_VERSION}

echo "🔹 Tagging image for ECR..."
docker tag mlflow/mlflow:${MLFLOW_VERSION} ${ECR_URI}:${MLFLOW_VERSION}

echo "🔹 Pushing to ECR..."
docker push ${ECR_URI}:${MLFLOW_VERSION}

echo "✅ Done. ECR Image: ${ECR_URI}:${MLFLOW_VERSION}"
