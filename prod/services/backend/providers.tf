
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.23.0"
  features {}
}

provider "aws" {}

provider "kubernetes" {
  load_config_file = false
  host             = data.azurerm_kubernetes_cluster.bosscluster.kube_config.0.host
  # token            = data.azurerm_kubernetes_cluster.bosscluster.kube_config.0.cluster_ca_certificate
  client_certificate     = base64decode(
    data.azurerm_kubernetes_cluster.bosscluster.kube_config.0.client_certificate
    )
  client_key = base64decode(
    data.azurerm_kubernetes_cluster.bosscluster.kube_config.0.client_key
    )
  cluster_ca_certificate = base64decode(
    data.azurerm_kubernetes_cluster.bosscluster.kube_config.0.cluster_ca_certificate
  )
}