# BACKEND CONF

resource "aws_ecr_repository" "backend" {
  name                 = var.backend_service["registry_name"]
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# FRONTEND CONF: MAIN

resource "aws_ecr_repository" "frontend" {
  name                 = var.frontend_service["registry_name"]
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# # FRONTEND CONF: FEED (MANAGEMENT DASH)

resource "aws_ecr_repository" "feed" {
  name                 = var.frontend_feed_service["registry_name"]
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# # FRONTEND AND BACKEND

resource "circleci_environment_variable" "aws_cr_env_variable" {
  project = local.cicd_projects["${count.index}"].circle_ci_project
  name    = "AWS_CR_URI"
  value   = local.cicd_ecr_containers_created["${count.index}"].repository_url
  count = 3
}


resource "circleci_environment_variable" "kubeconfig" {
  project = local.cicd_projects["${count.index}"].circle_ci_project
  name    = "KUBERNETES_KUBECONFIG"
  value   = base64encode(data.azurerm_kubernetes_cluster.bosscluster.kube_config_raw)
  count   = 3
}

resource "circleci_environment_variable" "aws_cicduser_access_key_id" {
  project = local.cicd_projects["${count.index}"].circle_ci_project
  name    = "AWS_ACCESS_KEY_ID"
  value   = file("${path.module}/../config/cicd_user_aws_access_key_id")
  count   = 3
}

resource "circleci_environment_variable" "aws_cicduser_secret_key" {
  project = local.cicd_projects["${count.index}"].circle_ci_project
  name    = "AWS_SECRET_ACCESS_KEY"
  value   = file("${path.module}/../config/cicd_user_aws_secret_key")
  count   = 3
}

resource "circleci_environment_variable" "aws_cicduser_region" {
  project = local.cicd_projects["${count.index}"].circle_ci_project
  name    = "AWS_DEFAULT_REGION"
  value   = var.region_aws
  count   = 3
}

