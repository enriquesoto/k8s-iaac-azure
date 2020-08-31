resource "kubernetes_namespace" "frontend" {
  metadata {
    annotations = {
      name = "frontend"
    }

    labels = {
      app = "frontend"
    }

    name = "frontend"
  }
}

resource "kubernetes_namespace" "frontend_feed" {
  metadata {
    annotations = {
      name = "frontend-feed"
    }

    labels = {
      app = "frontend-feed"
    }

    name = "frontend-feed"
  }
}

resource "kubernetes_namespace" "backend" {
  metadata {
    annotations = {
      name = "backend"
    }

    labels = {
      app = "backend"
    }

    name = "backend"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "monitoring"
    }

    labels = {
      app = "monitoring"
    }

    name = "monitoring"
  }
}

