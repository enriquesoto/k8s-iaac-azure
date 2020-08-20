resource "kubernetes_service" "frontend_service" {
  metadata {
    name      = "frontend-service"
    namespace = data.kubernetes_namespace.frontend.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.frontend_deploy.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 3000
    }
  }
}

resource "kubernetes_ingress" "frontend_ingress" {
  metadata {
    name      = "frontend-ingress"
    namespace = data.kubernetes_namespace.frontend.metadata.0.name
  }
  spec {
    tls {
      hosts       = [var.domain]
      secret_name = kubernetes_secret.tls_credentials_frontend.metadata.0.name
    }
    rule {
      host = var.domain
      http {
        path {
          backend {
            service_name = kubernetes_service.frontend_service.metadata.0.name
            service_port = "80"
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "frontend_feed_service" {
  metadata {
    name      = "frontend-feed-service"
    namespace = data.kubernetes_namespace.frontend_feed.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.frontend_feed_deploy.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 3000
    }
  }
}

resource "kubernetes_ingress" "frontend_feed_ingress" {
  metadata {
    name      = "frontend-feed-ingress"
    namespace = data.kubernetes_namespace.frontend_feed.metadata.0.name
  }
  spec {
    tls {
      hosts       = ["${local.feed_domain}"]
      secret_name = kubernetes_secret.tls_credentials_frontend.metadata.0.name
    }
    rule {
      host = local.feed_domain
      http {
        path {
          backend {
            service_name = kubernetes_service.frontend_feed_service.metadata.0.name
            service_port = "80"
          }
        }
      }
    }
  }
}
