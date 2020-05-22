resource "kubernetes_service" "coordinator_hs" {
  metadata {
    name      = "coordinator-hs"
    namespace = "$${namespace}"

    labels = {
      app = "coordinator"
    }
  }

  spec {
    port {
      name = "coordinator"
      port = 8081
    }

    selector = {
      app = "coordinator"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "coordinator_cs" {
  metadata {
    name      = "coordinator-cs"
    namespace = "$${namespace}"

    labels = {
      app = "coordinator"
    }
  }

  spec {
    port {
      name = "coordinator"
      port = 8081
    }

    selector = {
      app = "coordinator"
    }
  }
}



resource "kubernetes_deployment" "coordinator" {
  metadata {
    name      = "coordinator"
    namespace = "$${namespace}"

    labels = {
      app = "coordinator"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "coordinator"
      }
    }

    template {
      metadata {
        labels = {
          app = "coordinator"
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
          name  = "coordinator"
          image = "$${druid_image}:$${druid_tag}"

          port {
            name           = "coordinator"
            container_port = 8081
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
            value = "8081"
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
            value = "coordinator"
          }

          env {
            name  = "DRUID_JVM_ARGS"
            value = "-server -Xms1G -Xmx1G -XX:MaxDirectMemorySize=2G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -Dderby.stream.error.file=var/druid/derby.log"
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
              cpu    = "256m"
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
              port = "8081"
            }

            initial_delay_seconds = 60
          }

          readiness_probe {
            http_get {
              path = "/status/health"
              port = "8081"
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

