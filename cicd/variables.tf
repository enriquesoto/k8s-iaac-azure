variable "region_aws" {}

variable "circle_ci" {
  type = object({
    token = string
    organization = string
  })
}

variable "resource_group_name" {}

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

locals {
  cicd_projects = [var.backend_service, var.frontend_service, var.frontend_feed_service]
  cicd_ecr_containers_created = [aws_ecr_repository.backend, aws_ecr_repository.frontend, aws_ecr_repository.feed]
}

data "azurerm_kubernetes_cluster" "bosscluster" {
  name = "bosscluster"
  resource_group_name = var.resource_group_name
}