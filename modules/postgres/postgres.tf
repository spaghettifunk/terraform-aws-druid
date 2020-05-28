resource "kubernetes_namespace" "postgres_druid" {
  count = var.enable ? 1 : 0

  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service" "postgres_hs" {
  count = var.enable ? 1 : 0

  metadata {
    name      = "postgres-hs"
    namespace = kubernetes_namespace.postgres_druid

    labels = {
      app = "postgres"
    }
  }

  spec {
    port {
      name = "postgres"
      port = 5432
    }

    selector = {
      app = "postgres"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "postgres_cs" {
  count = var.enable ? 1 : 0

  metadata {
    name      = "postgres-cs"
    namespace = kubernetes_namespace.postgres_druid

    labels = {
      app = "postgres"
    }
  }

  spec {
    port {
      name = "postgres"
      port = 5432
    }

    selector = {
      app = "postgres"
    }
  }
}

resource "kubernetes_stateful_set" "postgres" {
  count = var.enable ? 1 : 0

  depends_on = [
    kubernetes_service.postgres_hs,
    kubernetes_service.postgres_cs,
  ]

  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.postgres_druid
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:latest"

          port {
            name           = "postgredb"
            container_port = 5432
          }

          env_from {
            config_map_ref {
              name = var.config_map_name
            }
          }

          volume_mount {
            name       = "postgredb"
            mount_path = "/var/lib/postgresql/data"
            sub_path   = "postgres"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "postgredb"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }

        storage_class_name = "gp2"
      }
    }

    service_name = "postgres"
  }
}

