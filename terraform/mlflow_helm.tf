resource "helm_release" "mlflow" {
  name             = "mlflow"
  namespace        = "mlflow"
  repository       = "https://community-charts.github.io/helm-charts"
  chart            = "mlflow"
  version          = "1.6.2"
  create_namespace = true
  wait             = true

  values = [
    <<-EOT
      backendStore:
        postgres:
          enabled: true
          host: mlflow-db
          port: 5432
          database: mlflow
          user: mlflow
          password: mlflowpass

      artifactRoot:
        s3:
          enabled: true
          bucket: ${aws_s3_bucket.ml_bucket.bucket}
          path: mlflow

      service:
        type: ClusterIP
        port: 5000

      image:
        repository: ${aws_ecr_repository.mlflow.repository_url}
        tag: "${var.mlflow_version}"    # ✅ explicit version, not latest
        pullPolicy: IfNotPresent        # safer, avoids unnecessary redeploys


      ingress:
        enabled: true
        className: alb
        hosts:
          - host: mlflow.example.com
            paths:
              - path: /
                pathType: Prefix
    EOT
  ]

  depends_on = [
    module.eks,
    aws_s3_bucket.ml_bucket,
    aws_ecr_repository.mlflow
  ]
}
