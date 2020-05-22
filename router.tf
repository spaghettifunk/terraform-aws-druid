resource "kubernetes_service" "router_hs" {
  metadata {
    name      = "router-hs"
    namespace = "$${namespace}"

    labels = {
      app = "router"
    }
  }

  spec {
    port {
      name = "router"
      port = 8888
    }

    selector = {
      app = "router"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "router_cs" {
  metadata {
    name      = "router-cs"
    namespace = "$${namespace}"

    labels = {
      app = "router"
    }
  }

  spec {
    port {
      name = "router"
      port = 8888
    }

    selector = {
      app = "router"
    }
  }
}



resource "kubernetes_deployment" "router" {
  metadata {
    name      = "router"
    namespace = "$${namespace}"

    labels = {
      app = "router"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "router"
      }
    }

    template {
      metadata {
        labels = {
          app = "router"
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
          name  = "router"
          image = "$${druid_image}:$${druid_tag}"

          port {
            name           = "router"
            container_port = 8888
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
            value = "8888"
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
            value = "router"
          }

          env {
            name  = "DRUID_JVM_ARGS"
            value = "-server -Xms256m -Xmx256m -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"
          }

          env {
            name = "AWS_REGION"

            value_from {
              secret_key_ref {
                name = "druid-secret"
                key  = "aws_access_key"
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
              memory = "512Mi"
              cpu    = "128m"
            }

            requests {
              cpu    = "128m"
              memory = "256Mi"
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/druid/"
          }

          liveness_probe {
            http_get {
              path = "/status/health"
              port = "8888"
            }

            initial_delay_seconds = 60
          }

          readiness_probe {
            http_get {
              path = "/status/health"
              port = "8888"
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

