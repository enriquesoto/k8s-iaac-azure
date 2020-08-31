provider "helm" {
  kubernetes {
    host = data.azurerm_kubernetes_cluster.bosscluster.kube_config.0.host
    # token            = azurerm_kubernetes_cluster.bosscluster.kube_config.0.cluster_ca_certificate
    client_certificate = base64decode(
      data.azurerm_kubernetes_cluster.bosscluster.kube_config.0.client_certificate
    )
    client_key = base64decode(
      data.azurerm_kubernetes_cluster.bosscluster.kube_config.0.client_key
    )
    cluster_ca_certificate = base64decode(
      data.azurerm_kubernetes_cluster.bosscluster.kube_config.0.cluster_ca_certificate
    )
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  chart      = "prometheus"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  version    = var.prometheus_version
  namespace  = data.kubernetes_namespace.monitoring.metadata.0.name
  # https://github.com/hashicorp/terraform-provider-helm/issues/537
  verify = false
}

data "kubernetes_service" "prometheus_service" {
  metadata {
    name      = "prometheus-server"
    namespace = data.kubernetes_namespace.monitoring.metadata.0.name
  }
  depends_on = [helm_release.prometheus]
}


resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "grafana"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  version    = var.grafana_version
  namespace  = data.kubernetes_namespace.monitoring.metadata.0.name
  values = [
    templatefile("${path.module}/templates/grafana-values.yaml.tpl", {
      LOGIN_SECRETS = kubernetes_secret.grafana_login_secrets.metadata.0.name,
      DOMAIN        = "${local.monitoring_domain}"
    })
  ]
}

