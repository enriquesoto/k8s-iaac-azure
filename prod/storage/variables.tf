variable "environment" {
  default = "production"
}

variable "domain" {}

variable "arn_user_backend" {}

variable "prod_bucket_subdomain" {}

variable "pg_version" {
  default = "11"
}

variable "database_name" {}

variable "postgresql_admin_username" {
}

variable "postgresql_admin_password" {
}
// ci cd conf for backend deployment 

variable "backend_service" {
  type = object({
    name = string
    registry_name = string
    circle_ci_project = string
    subdomain = string
  })
}

// ci cd conf for front end deployment 

variable "frontend_service" {
  type = object({
    name = string
    registry_name = string
    circle_ci_project = string
  })
}

variable "frontend_feed_service" {
  type = object({
    name = string
    registry_name = string
    circle_ci_project = string
    subdomain = string
  })
}

#  not used due tier not ompatible 

data "azurerm_virtual_network" "prod_vpc" {
  name                = "prod-vpc"
  resource_group_name = data.azurerm_resource_group.main_resource_group.name
}

data "azurerm_subnet" "akspodssubnet" {
    name                        = "akspodssubnet"
    virtual_network_name = data.azurerm_virtual_network.prod_vpc.name
    resource_group_name = data.azurerm_resource_group.main_resource_group.name
}

## end 


data "azurerm_resource_group" "main_resource_group" {
  name     = "main_resource_group"
}
locals {
  prod_bucket_name = "${var.prod_bucket_subdomain}.${var.domain}"
}