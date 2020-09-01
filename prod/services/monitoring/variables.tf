variable "resource_group_name" {}

variable "prometheus_version" {
  default = "11.12.0"
}

variable "grafana_username" {
}

variable "grafana_password" {

}

variable "grafana_version" {
  default = "5.5.0"
}

variable "fluentbit_version" {
  default = "2.10.0"
}

variable "domain" {}


variable "monitoring_service" {
  type = object({
    name      = string
    subdomain = string
  })
}

variable "elasticsearch_host" {
}

variable "elasticsearch_user" {
}

variable "elasticsearch_password" {

}

locals {
  monitoring_domain = "${var.monitoring_service.subdomain}.${var.domain}"
}


data "azurerm_kubernetes_cluster" "bosscluster" {
  name                = "bosscluster"
  resource_group_name = var.resource_group_name
}

data "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

data "kubernetes_namespace" "logging" {
  metadata {
    name = "logging"
  }
}
