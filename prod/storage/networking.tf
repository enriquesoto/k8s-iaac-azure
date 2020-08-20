#  This feature is not available for the selected edition 'Basic'.
#  https://www.terraform.io/docs/providers/azurerm/r/postgresql_virtual_network_rule.html


# resource "azurerm_postgresql_virtual_network_rule" "example" {
#   name                                 = "postgresql-vnet-rule"
#   resource_group_name                  = data.azurerm_resource_group.main_resource_group.name
#   server_name                          = azurerm_postgresql_server.pgsql_server_main.name
#   subnet_id                            = data.azurerm_subnet.akspodssubnet.id
#   ignore_missing_vnet_service_endpoint = true
# }