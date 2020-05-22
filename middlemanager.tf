resource "kubernetes_service" "mm_hs" {
  metadata {
    name      = "mm-hs"
    namespace = var.namespace

    labels = {
      app = "middlemanager"
    }
  }

  spec {
    port {
      name = "mm"
      port = 8084
    }

    selector = {
      app = "middlemanager"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "mm_cs" {
  metadata {
    name      = "mm-cs"
    namespace = var.namespace

    labels = {
      app = "middlemanager"
    }
  }

  spec {
    port {
      name = "mm"
      port = 8084
    }

    selector = {
      app = "middlemanager"
    }
  }
}



resource "kubernetes_deployment" "middlemanager" {
  metadata {
    name      = "middlemanager"
    namespace = var.namespace

    labels = {
      app = "middlemanager"
    }
  }

  spec {
    replicas = var.middlemanager_replicas

    selector {
      match_labels = {
        app = "middlemanager"
      }
    }

    template {
      metadata {
        labels = {
          app = "middlemanager"
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
          name  = "middlemanager"
          image = "$${druid_image}:$${druid_tag}"

          port {
            name           = "middlemanager"
            container_port = 8084
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
            value = "8084"
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
            value = "middleManager"
          }

          env {
            name  = "DRUID_JVM_ARGS"
            value = "-server -Xms4G -Xmx4G -XX:MaxDirectMemorySize=12G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"
          }

          env {
            name  = "JVM_PEONS_ARGS"
            value = "-Daws.region=eu-west-1"
          }

          env_from {
            secret_ref {
              name = "druid-secret"
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
              port = "8084"
            }

            initial_delay_seconds = 60
          }

          readiness_probe {
            http_get {
              path = "/status/health"
              port = "8084"
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

