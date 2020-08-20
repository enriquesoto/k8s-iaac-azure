resource "kubernetes_secret" "docker_credentials_frontend" {
  metadata {
    name      = "docker-credentials-frontend"
    namespace = data.kubernetes_namespace.frontend.metadata.0.name
  }

  data = {
    ".dockerconfigjson" = file("${path.module}/../../../config/docker-aws.json")
  }
  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret" "docker_credentials_frontend_feed" {
  metadata {
    name      = "docker-credentials-frontend-feed"
    namespace = data.kubernetes_namespace.frontend_feed.metadata.0.name
  }

  data = {
    ".dockerconfigjson" = file("${path.module}/../../../config/docker-aws.json")
  }
  type = "kubernetes.io/dockerconfigjson"
}




resource "kubernetes_secret" "tls_credentials_frontend" {
  type = "kubernetes.io/tls"


  metadata {
    name      = "tls-credentials-frontend"
    namespace = data.kubernetes_namespace.frontend.metadata.0.name
  }

  data = {
    "tls.crt" = file("${path.module}/../../../config/cred.crt")
    "tls.key" = file("${path.module}/../../../config/cred.key")
  }
}
