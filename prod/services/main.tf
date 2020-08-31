terraform {
  backend "s3" {
    bucket         = "memefier-remote-state-s3-azure"
    key            = "prod/services/terraform.tfstate"
    encrypt        = true
  }
}

resource "azurerm_kubernetes_cluster" "bosscluster" {
  name                = "bosscluster"
  location            = data.azurerm_resource_group.main_resource_group.location
  resource_group_name =  data.azurerm_resource_group.main_resource_group.name
  dns_prefix          = "k8s"
  kubernetes_version = var.k8s_version

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = var.vm_size
    # default cidr
    # service_cidr = ["10.0.0.0/16"]
    # dns_service_ip = ["10.0.0.10"]
    # docker_bridge_cidr = ["172.17.0.1/16"]
    vnet_subnet_id = azurerm_subnet.akspodssubnet.id
  }

  network_profile {
    network_plugin    = "azure"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
