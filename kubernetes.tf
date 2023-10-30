provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "brahim10"  # Namespace name
  }
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "ts-techical-test-app-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "ts-techical-test-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "ts-techical-test-app"
        }
      }

      spec {
        container {
          name           = "ts-techical-test-app"
          image          = "ts-techical-test-app:latest"  # Docker image to deploy
          image_pull_policy = "IfNotPresent"  # Set the imagePullPolicy
        }
      }
    }
  }
}
