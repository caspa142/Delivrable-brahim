provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "brahim2"  # Namespace name
  }
}

resource "helm_release" "example" {
  name       = "ts-technical-test-app"
  chart      = "ts-technical-test-app"  # Replace with your Helm Chart name
  namespace  = kubernetes_namespace.example.metadata[0].name
  values = [
    file("~/ts-technical-test-app/values.yaml"),  # Path to your Helm Chart values file
  ]
}
