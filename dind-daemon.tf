resource "kubernetes_daemonset" "dind" {
  depends_on = ["kubernetes_namespace.jenkins"]
  metadata {
    name = "dind"
    namespace = "jenkins"
    labels {
      role = "ci"
    }
  }

  spec {
    selector {
      match_labels {
        role = "ci"
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = 1
      }
    }

    template {
      metadata {
        labels {
          role = "ci"
        }
      }

      spec {

      termination_grace_period_seconds = "45"
      volume {
        name = "varlibdocker"
        empty_dir = {}
      }
      volume {
        name = "rundind"
        host_path {
          path = "/var/run/dind/"
        }
      }
        container {
          image = "docker:dind"
          name  = "dind"
          args = ["dockerd",
                  "--storage-driver=overlay2",
                  "-H unix:///var/run/dind/docker.sock"]
          security_context {
             privileged = true
          }

          #resources{
          #  limits{
          #    cpu    = "0.5"
          #    memory = "512Mi"
          #  }
          #  requests{
          #    cpu    = "250m"
          #    memory = "50Mi"
          #  }
          #}

          volume_mount {
            mount_path = "/var/lib/docker"
            name = "varlibdocker"
          }

          volume_mount {
            mount_path = "/var/run/dind"
            name = "rundind"
          }

        }
      }

    }

  }
}
