resource "kubernetes_secret" "ghcr" {
  metadata {
    name      = "ghcr-secret"
    namespace = "mlflow"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = base64encode(
      jsonencode({
        auths = {
          "ghcr.io" = {
            username = var.ghcr_username
            password = var.ghcr_token
            auth     = base64encode("${var.ghcr_username}:${var.ghcr_token}")
          }
        }
      })
    )
  }
}
