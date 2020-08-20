provider "azurerm" {
  version = "=2.23.0"
  features {}
}

provider "aws" {}

provider "kubernetes" {
  load_config_file = false
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


