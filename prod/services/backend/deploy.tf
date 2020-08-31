resource "kubernetes_deployment" "backend_deploy" {
  metadata {
    name = "backend-deploy"
    labels = {
      app = "backend"
    }
    namespace = data.kubernetes_namespace.backend.metadata.0.name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }
      spec {
        image_pull_secrets {
          name = kubernetes_secret.docker_credentials_backend.metadata.0.name
        }
        container {
          image             = data.aws_ecr_repository.backend.repository_url
          name              = "backend"
          image_pull_policy = "Always"
          port {
            container_port = 8080
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.prod_env_variables.metadata.0.name
            }
          }
          resources {
            requests {
              cpu    = "496m"
              memory = "496Mi"
            }

            limits {
              cpu    = "496m"
              memory = "496Mi"
            }
          }
          volume_mount {
            name       = var.credential_volume_name
            mount_path = "/etc/gcp"
            read_only  = true
          }
        }

        volume {
          name = var.credential_volume_name
          secret {
            secret_name = kubernetes_secret.google_service_account.metadata.0.name
            items {
              key  = "google_service_account"
              path = "google-service-account.json"
            }
          }
        }

      }
    }
  }
}
