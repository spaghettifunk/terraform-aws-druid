resource "kubernetes_service" "overlord_hs" {
  metadata {
    name      = "overlord-hs"
    namespace = "$${namespace}"

    labels = {
      app = "overlord"
    }
  }

  spec {
    port {
      name = "overlord"
      port = 8090
    }

    selector = {
      app = "overlord"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "overlord_cs" {
  metadata {
    name      = "overlord-cs"
    namespace = "$${namespace}"

    labels = {
      app = "overlord"
    }
  }

  spec {
    port {
      name = "overlord"
      port = 8090
    }

    selector = {
      app = "overlord"
    }
  }
}



resource "kubernetes_deployment" "overlord" {
  metadata {
    name      = "overlord"
    namespace = "$${namespace}"

    labels = {
      app = "overlord"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "overlord"
      }
    }

    template {
      metadata {
        labels = {
          app = "overlord"
        }
      }

      spec {
        volume {
          name = "druid-secret"

          secret {
            secret_name = "druid-secret"
          }
        }

        volume {
          name = "data"
        }

        container {
          name  = "overlord"
          image = "$${druid_image}:$${druid_tag}"

          port {
            name           = "overlord"
            container_port = 8090
          }

          env_from {
            config_map_ref {
              name = "postgres-config"
            }
          }

          env {
            name  = "POSTGRES_URL"
            value = "postgres-cs.$${namespace}.svc.cluster.local"
          }

          env {
            name  = "ZOOKEEPER_SERVER"
            value = "zk-cs.$${namespace}.svc.cluster.local"
          }

          env {
            name  = "DRUID_SERVICE_PORT"
            value = "8090"
          }

          env {
            name = "DRUID_HOST"

            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          env {
            name  = "DRUID_SERVICE"
            value = "overlord"
          }

          env {
            name  = "DRUID_JVM_ARGS"
            value = "-server -Xms1G -Xmx1G -XX:MaxDirectMemorySize=2G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"
          }

          env_from {
            secret_ref {
              name = "druid-secret"
            }
          }

          resources {
            limits {
              cpu    = "512m"
              memory = "2Gi"
            }

            requests {
              cpu    = "256m"
              memory = "2Gi"
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/druid/"
          }

          liveness_probe {
            http_get {
              path = "/status/health"
              port = "8090"
            }

            initial_delay_seconds = 60
          }

          readiness_probe {
            http_get {
              path = "/status/health"
              port = "8090"
            }

            initial_delay_seconds = 60
          }

          image_pull_policy = "Always"

          security_context {
            capabilities {
              add = ["IPC_LOCK"]
            }
          }
        }

        termination_grace_period_seconds = 1800
      }
    }
  }
}

