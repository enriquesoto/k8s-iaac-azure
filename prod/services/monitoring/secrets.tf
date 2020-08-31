resource "kubernetes_secret" "prometheus_tls" {
  type = "kubernetes.io/tls"

  metadata {
    name      = "prometheus-tls"
    namespace = data.kubernetes_namespace.monitoring.metadata.0.name
  }

  data = {
    "tls.crt" = file("${path.module}/../../../config/cred.crt")
    "tls.key" = file("${path.module}/../../../config/cred.key")
  }
}

resource "kubernetes_secret" "grafana_login_secrets" {
  metadata {
    name      = "grafana-login-secrets"
    namespace = data.kubernetes_namespace.monitoring.metadata.0.name
  }

  data = {
    "admin-user"     = var.grafana_username
    "admin-password" = var.grafana_password
  }
}
