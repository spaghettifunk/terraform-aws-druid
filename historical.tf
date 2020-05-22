resource "kubernetes_service" "historical_hs" {
  metadata {
    name      = "historical-hs"
    namespace = "$${namespace}"

    labels = {
      app = "historical"
    }
  }

  spec {
    port {
      name = "historical"
      port = 8083
    }

    selector = {
      app = "historical"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "historical_cs" {
  metadata {
    name      = "historical-cs"
    namespace = "$${namespace}"

    labels = {
      app = "historical"
    }
  }

  spec {
    port {
      name = "historical"
      port = 8083
    }

    selector = {
      app = "historical"
    }
  }
}



resource "kubernetes_deployment" "historical" {
  metadata {
    name      = "historical"
    namespace = "$${namespace}"

    labels = {
      app = "historical"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "historical"
      }
    }

    template {
      metadata {
        labels = {
          app = "historical"
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
          name  = "historical"
          image = "$${druid_image}:$${druid_tag}"

          port {
            name           = "historical"
            container_port = 8083
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
            value = "8083"
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
            value = "historical"
          }

          env {
            name  = "DRUID_JVM_ARGS"
            value = "-server -Xms4G -Xmx4G -XX:MaxDirectMemorySize=12G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -XX:NewSize=4G -XX:MaxNewSize=4G -XX:+UseConcMarkSweepGC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"
          }

          env {
            name = "AWS_REGION"

            value_from {
              secret_key_ref {
                name = "druid-secret"
                key  = "aws_region"
              }
            }
          }

          env {
            name = "AWS_ACCESS_KEY"

            value_from {
              secret_key_ref {
                name = "druid-secret"
                key  = "aws_access_key"
              }
            }
          }

          env {
            name = "AWS_SECRET_KEY"

            value_from {
              secret_key_ref {
                name = "druid-secret"
                key  = "aws_secret_key"
              }
            }
          }

          env {
            name = "BUCKET_STORAGE"

            value_from {
              secret_key_ref {
                name = "druid-secret"
                key  = "aws_bucket_storage"
              }
            }
          }

          env {
            name = "BUCKET_INDEX"

            value_from {
              secret_key_ref {
                name = "druid-secret"
                key  = "aws_bucket_index"
              }
            }
          }

          resources {
            limits {
              cpu    = "512m"
              memory = "8Gi"
            }

            requests {
              cpu    = "256m"
              memory = "4Gi"
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/druid/"
          }

          liveness_probe {
            http_get {
              path = "/status/health"
              port = "8083"
            }

            initial_delay_seconds = 60
          }

          readiness_probe {
            http_get {
              path = "/status/health"
              port = "8083"
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

