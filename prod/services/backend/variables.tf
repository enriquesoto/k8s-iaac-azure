variable "google_proyect_id" {}

variable "allowed_hosts" {}

variable "aws_access_key_id_backend_user" {}

variable "aws_secret_key_backend_user" {}

variable "google_api_key_backend_account" {}

variable "google_api_cloud_vision_backend_account" {}

variable "sendgrid_api_key" {}

variable "sentry_dsn" {}

variable "prod_bucket_subdomain" {}

variable "domain" {}

variable "cors_origin_whitelist_strings" {}

variable "facebook_app_secret" {}

variable "credential_volume_name" {
  default = "service-account-credentials-volume"
}

variable "resource_group_name" {}

variable "database_name" {}

variable "database_password" {}

variable "backend_service" {
  type = object({
    name = string
    registry_name = string
    circle_ci_project = string
    subdomain = string
  })
}

data "kubernetes_namespace" "backend" {
  metadata {
    name = "backend"
  }
}

data "azurerm_postgresql_server" "pgsql_server_main" {
  name                = "pgsql-server-main"
  resource_group_name = var.resource_group_name
}

data "azurerm_kubernetes_cluster" "bosscluster" {
  name                = "bosscluster"
  resource_group_name = var.resource_group_name
}

data "aws_ecr_repository" "backend" {
  name = var.backend_service.registry_name
}


locals {
  prod_bucket_name = "${var.prod_bucket_subdomain}.${var.domain}"
  backend_domain   = "${var.backend_service.subdomain}.${var.domain}"
  username = urlencode("${data.azurerm_postgresql_server.pgsql_server_main.administrator_login}@pgsql-server-main")
  password = var.database_password
  host = data.azurerm_postgresql_server.pgsql_server_main.fqdn
  conection_string = "postgresql://${local.username}:${local.password}@${local.host}:5432/${var.database_name}?sslmode=require"
}

output "connection_string" {
  value= local.conection_string
}
