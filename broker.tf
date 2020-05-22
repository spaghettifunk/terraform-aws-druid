resource "kubernetes_service" "broker_hs" {
  metadata {
    name      = "broker-hs"
    namespace = "$${namespace}"

    labels = {
      app = "broker"
    }
  }

  spec {
    port {
      name = "broker"
      port = 8082
    }

    selector = {
      app = "broker"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "broker_cs" {
  metadata {
    name      = "broker-cs"
    namespace = "$${namespace}"

    labels = {
      app = "broker"
    }
  }

  spec {
    port {
      name = "broker"
      port = 8082
    }

    selector = {
      app = "broker"
    }
  }
}

resource "kubernetes_deployment" "broker" {
  metadata {
    name      = "broker"
    namespace = "$${namespace}"

    labels = {
      app = "broker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "broker"
      }
    }

    template {
      metadata {
        labels = {
          app = "broker"
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
          name  = "broker"
          image = "$${druid_image}:$${druid_tag}"

          port {
            name           = "broker"
            container_port = 8082
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
            value = "8082"
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
            value = "broker"
          }

          env {
            name  = "DRUID_JVM_ARGS"
            value = "-server -Xms4G -Xmx4G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -XX:NewSize=4G -XX:MaxNewSize=4G -XX:MaxDirectMemorySize=12G -XX:+UseG1GC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"
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
              memory = "8Gi"
              cpu    = "512m"
            }

            requests {
              cpu    = "512m"
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
              port = "8082"
            }

            initial_delay_seconds = 60
          }

          readiness_probe {
            http_get {
              path = "/status/health"
              port = "8082"
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

