variable "domain" {}

variable "resource_group_name" {}

// ci cd conf for front end deployment 

variable "frontend_service" {
  type = object({
    name = string
    registry_name = string
    circle_ci_project = string
    credentials_docker= string
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


data "kubernetes_namespace" "frontend" {
  metadata {
    name = "frontend"
  }
}

data "kubernetes_namespace" "frontend_feed" {
  metadata {
    name = "frontend-feed"
  }
}

data "azurerm_kubernetes_cluster" "bosscluster" {
  name                = "bosscluster"
  resource_group_name = var.resource_group_name
}

data "aws_ecr_repository" "frontend" {
  name = var.frontend_service.registry_name
}

data "aws_ecr_repository" "aws_cr_feed" {
  name =var.frontend_feed_service.registry_name
}


locals {
  feed_domain = "${var.frontend_feed_service.subdomain}.${var.domain}"
}
