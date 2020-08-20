resource "kubernetes_service" "backend_service" {
  metadata {
    name      = "backend-service"
    namespace = data.kubernetes_namespace.backend.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.backend_deploy.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 8000
    }
  }
}

resource "kubernetes_ingress" "backend_ingress" {
  metadata {
    name      = "backend-ingress"
    namespace = data.kubernetes_namespace.backend.metadata.0.name
  }
  spec {
    tls {
      hosts       = ["${local.backend_domain}"]
      secret_name = kubernetes_secret.tls_credentials_backend.metadata.0.name
    }
    rule {
      host = local.backend_domain
      http {
        path {
          backend {
            service_name = kubernetes_service.backend_service.metadata.0.name
            service_port = "80"
          }
        }
      }
    }
  }
}
