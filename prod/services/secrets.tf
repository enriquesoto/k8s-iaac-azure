
resource "kubernetes_secret" "cicd_aws_credentials_backend" {
  metadata {
    name      = "cicd-aws-credentials-backend"
    namespace = kubernetes_namespace.backend.metadata.0.name
  }
  data = {
    NAMESPACE = kubernetes_namespace.backend.metadata.0.name
    AWS_ACCESS_KEY_ID            = file("${path.module}/../../config/cicd_user_aws_access_key_id")
    AWS_SECRET_ACCESS_KEY        = file("${path.module}/../../config/cicd_user_aws_secret_key")
    AWS_DEFAULT_REGION = var.region_aws
    AWS_CR_URI = data.aws_ecr_repository.backend.repository_url
    DOCKER_CRED_NAME = data.kubernetes_secret.docker_credentials_backend.metadata.0.name
    KUBERNETES_KUBECONFIG = base64encode(azurerm_kubernetes_cluster.bosscluster.kube_config_raw)
  }
}

resource "kubernetes_secret" "cicd_aws_credentials_frontend" {
  metadata {
    name      = "cicd-aws-credentials-frontend"
    namespace = data.kubernetes_namespace.frontend.metadata.0.name
  }
  data = {
    NAMESPACE = data.kubernetes_namespace.frontend.metadata.0.name
    AWS_ACCESS_KEY_ID            = file("${path.module}/../../config/cicd_user_aws_access_key_id")
    AWS_SECRET_ACCESS_KEY        = file("${path.module}/../../config/cicd_user_aws_secret_key")
    AWS_DEFAULT_REGION = var.region_aws
    AWS_CR_URI = data.aws_ecr_repository.frontend.repository_url
    DOCKER_CRED_NAME = data.kubernetes_secret.docker_credentials_frontend.metadata.0.name
    KUBERNETES_KUBECONFIG = base64encode(azurerm_kubernetes_cluster.bosscluster.kube_config_raw)
  }
}

resource "kubernetes_secret" "cicd_aws_credentials_frontend_feed" {
  metadata {
    name      = "cicd-aws-credentials-frontend-feed"
    namespace = kubernetes_namespace.frontend_feed.metadata.0.name
  }
  data = {
    NAMESPACE = kubernetes_namespace.frontend_feed.metadata.0.name
    AWS_ACCESS_KEY_ID            = file("${path.module}/../../config/cicd_user_aws_access_key_id")
    AWS_SECRET_ACCESS_KEY        = file("${path.module}/../../config/cicd_user_aws_secret_key")
    AWS_DEFAULT_REGION = var.region_aws
    AWS_CR_URI = data.aws_ecr_repository.feed.repository_url
    DOCKER_CRED_NAME = data.kubernetes_secret.docker_credentials_frontend_feed.metadata.0.name
    KUBERNETES_KUBECONFIG = base64encode(azurerm_kubernetes_cluster.bosscluster.kube_config_raw)
  }
}