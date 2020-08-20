# Configure the DigitalOcean Provider
# provider "digitalocean" {
#   token = var.do_token
# }

provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~>2.20.0"
  features {}
}

# config loaded from env variables
provider "aws" {}

provider "cloudflare" {
  version   = "~> 2.0"
  email     = var.cloudflare_email
  api_token = var.cloudflare_api_token
}

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

