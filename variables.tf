# variable "do_token" {}

variable "domain" {}

variable "region_aws" {}

variable "cloudflare_email" {}

variable "cloudflare_api_token" {}

variable "terraform_remote_state_bucket" {
  default = "memefier-remote-state-s3-azure"
}

variable "resource_group_name" {}

variable "backend_service" {
  type = object({
    name              = string
    registry_name     = string
    circle_ci_project = string
    subdomain         = string
  })
}

variable "frontend_service" {
  type = object({
    name              = string
    registry_name     = string
    circle_ci_project = string
  })
}

variable "frontend_feed_service" {
  type = object({
    name              = string
    registry_name     = string
    circle_ci_project = string
    subdomain         = string
  })
}

variable "monitoring_service" {
  type = object({
    name      = string
    subdomain = string
  })
}




data "azurerm_kubernetes_cluster" "bosscluster" {
  name                = "bosscluster"
  resource_group_name = var.resource_group_name
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-ingress-nginx-controller"
    namespace = "kube-system"
  }
}

variable "prod_bucket_subdomain" {}

# // locals

locals {
  bucket_prod_subdomain   = "${var.prod_bucket_subdomain}.${var.domain}"
  bucket_prod_cname_value = "${local.bucket_prod_subdomain}.s3.amazonaws.com"
}


