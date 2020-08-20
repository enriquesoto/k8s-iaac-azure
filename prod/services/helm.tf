provider "helm" {
  kubernetes {
    host             = azurerm_kubernetes_cluster.bosscluster.kube_config.0.host
  # token            = azurerm_kubernetes_cluster.bosscluster.kube_config.0.cluster_ca_certificate
  client_certificate     = base64decode(
    azurerm_kubernetes_cluster.bosscluster.kube_config.0.client_certificate
    )
  client_key = base64decode(
    azurerm_kubernetes_cluster.bosscluster.kube_config.0.client_key
    )
  cluster_ca_certificate = base64decode(
    azurerm_kubernetes_cluster.bosscluster.kube_config.0.cluster_ca_certificate
  )
  }
}


resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  set {
    name = "controller.config.proxy-body-size"
    value = "8m"
    type = "string"
  }
}