resource "kubernetes_namespace" "jenkins" {
  metadata {
    annotations {
      name = "jenkins"
    }

    labels {
      purpose = "ci"
    }

    name = "jenkins"
  }
}
