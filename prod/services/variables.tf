variable "k8s_version" {}

variable "vm_size" {
  default = "Standard_B2s"
}

variable "region_aws" {}

// ci cd conf for backend deployment 

variable "backend_service" {
  type = object({
    name = string
    registry_name = string
    circle_ci_project = string
    subdomain = string
    credentials_docker= string
  })
}

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

# data "digitalocean_kubernetes_cluster" "bosscluster" {
#   name = "bosscluster"
# }

data "aws_ecr_repository" "backend" {
  name = var.backend_service.registry_name
}

data "aws_ecr_repository" "frontend" {
  name = var.frontend_service.registry_name
}

data "aws_ecr_repository" "feed" { 
  name = var.frontend_feed_service.registry_name
}

data "kubernetes_namespace" "backend" {
  metadata {
    name = "backend"
  }
}

data "kubernetes_namespace" "frontend" {
  metadata {
    name = "frontend"
  }
}

data "kubernetes_secret" "docker_credentials_backend" {
  metadata {
    name      = "docker-credentials-backend"
    namespace = kubernetes_namespace.backend.metadata.0.name
  }
}

data "kubernetes_secret" "docker_credentials_frontend" {
  metadata {
    name      = "docker-credentials-frontend"
    namespace = kubernetes_namespace.frontend.metadata.0.name
  }
}

data "kubernetes_secret" "docker_credentials_frontend_feed" {
  metadata {
    name      = "docker-credentials-frontend-feed"
    namespace = kubernetes_namespace.frontend_feed.metadata.0.name
  }
}