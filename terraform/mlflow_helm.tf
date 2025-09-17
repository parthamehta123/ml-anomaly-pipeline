resource "helm_release" "mlflow" {
  name             = "mlflow"
  repository       = "https://community-charts.github.io/helm-charts"
  chart            = "mlflow"
  namespace        = "mlflow"
  create_namespace = true
  values           = [file("${path.module}/../k8s/helm-mlflow/values.yml")]
}
