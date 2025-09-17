resource "helm_release" "mlflow" {
  name = "mlflow"
  namespace = "mlflow"
  repository = "https://community-charts.github.io/helm-charts"
  chart = "mlflow"
  version = "0.6.10"
  create_namespace = true
  values = [ file("${path.module}/../k8s/helm-mlflow/values.yaml") ]
}