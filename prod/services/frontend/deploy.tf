
resource "kubernetes_deployment" "frontend_deploy" {
  metadata {
    name = "frontend-deploy"
    labels = {
      app = "frontend"
    }
    namespace = data.kubernetes_namespace.frontend.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }
      spec {
        image_pull_secrets {
          name = kubernetes_secret.docker_credentials_frontend.metadata.0.name
        }
        container {
          image             = data.aws_ecr_repository.frontend.repository_url
          name              = "frontend"
          image_pull_policy = "Always"
          port {
            container_port = 8080
          }
          resources {
            limits {
              cpu    = "196m"
              memory = "256Mi"
            }
            requests {
              cpu    = "196m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "frontend_feed_deploy" {
  metadata {
    name = "frontend-feed-deploy"
    labels = {
      app = "frontend-feed"
    }
    namespace = data.kubernetes_namespace.frontend_feed.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "frontend-feed"
      }
    }
    template {
      metadata {
        labels = {
          app = "frontend-feed"
        }
      }
      spec {
        image_pull_secrets {
          name = kubernetes_secret.docker_credentials_frontend_feed.metadata.0.name
        }
        container {
          image             = data.aws_ecr_repository.aws_cr_feed.repository_url
          name              = "frontend-feed"
          image_pull_policy = "Always"
          port {
            container_port = 8080
          }
          resources {
            limits {
              cpu    = "80m"
              memory = "160Mi"
            }
            requests {
              cpu    = "80m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}
