resource "kubernetes_service" "coordinator_cs" {
  metadata {
    name      = "coordinator-cs"
    namespace = var.namespace

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
    namespace = var.namespace

    labels = {
      app = "coordinator"
    }
  }

  spec {
    replicas = var.coordinator_replicas

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
        container {
          name  = "coordinator"
          image = var.druid_image

          port {
            name           = "coordinator"
            container_port = 8081
          }

          env_from {
            config_map_ref {
              name = "druid-common-config"
            }
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
            value = "-server -Xms2G -Xmx2G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -Dderby.stream.error.file=var/druid/derby.log"
          }

          env_from {
            secret_ref {
              name = "druid-secret"
            }
          }

          resources {
            limits   = var.coordinator_limits
            requests = var.coordinator_requests
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
          for_each = [for t in var.coordinator_tolerations : {
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
                  values   = ["coordinator"]
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
