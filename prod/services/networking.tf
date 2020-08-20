data "azurerm_resource_group" "main_resource_group" {
    name     = "main_resource_group"
}

resource "azurerm_virtual_network" "prod_vpc" {
  name                = "prod-vpc"
  resource_group_name = data.azurerm_resource_group.main_resource_group.name
  location            = data.azurerm_resource_group.main_resource_group.location
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "akspodssubnet" {
    name                        = "akspodssubnet"
    resource_group_name         = data.azurerm_resource_group.main_resource_group.name
    virtual_network_name        = azurerm_virtual_network.prod_vpc.name
    address_prefixes              = ["10.1.0.0/16"]
}