resource "kubernetes_service" "historical_hs" {
  metadata {
    name      = "historical-hs"
    namespace = var.namespace

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
    namespace = var.namespace

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
    namespace = var.namespace

    labels = {
      app = "historical"
    }
  }

  spec {
    replicas = var.historical_replicas

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
        container {
          name  = "historical"
          image = var.druid_image

          port {
            name           = "historical"
            container_port = 8083
          }

          env_from {
            config_map_ref {
              name = "druid-common-config"
            }
          }

          env_from {
            secret_ref {
              name = "druid-secret"
            }
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
            value = "-server -Xms8G -Xmx8G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -XX:+UseConcMarkSweepGC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"
          }

          resources {
            limits   = var.historical_limits
            requests = var.historical_requests
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

        volume {
          name = "druid-secret"

          secret {
            secret_name = "druid-secret"
          }
        }

        volume {
          name = "data"
        }

        dynamic "toleration" {
          for_each = [for t in var.historical_tolerations : {
            effect             = t.effect
            key                = t.key
            operator           = t.operator
            toleration_seconds = t.toleration_seconds
            value              = t.value
          }]

          content {
            effect             = toleration.value.effect
            key                = toleration.value.key
            operator           = toleration.value.operator
            toleration_seconds = toleration.value.toleration_seconds
            value              = toleration.value.value
          }
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["historical"]
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        termination_grace_period_seconds = 1800
      }
    }
  }
}
