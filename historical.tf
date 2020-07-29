resource "kubernetes_service" "historical_cs" {
  metadata {
    name      = "historical-cs"
    namespace = var.namespace

    labels = local.historical_labels
  }
  spec {
    port {
      name = "historical"
      port = 8083
    }
    selector = local.historical_labels
  }
}

resource "kubernetes_deployment" "historical" {
  metadata {
    name      = "historical"
    namespace = var.namespace
    labels    = local.historical_labels
  }

  spec {
    replicas = var.historical_replicas
    selector {
      match_labels = local.historical_labels
    }
    template {
      metadata {
        labels = local.historical_labels
      }
      spec {
        container {
          name              = "historical"
          image             = local.druid_image
          image_pull_policy = "Always"

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
            name = "DRUID_HOST"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          dynamic "env" {
            for_each = local.historical_env_variables
            content {
              name  = env.value.name
              value = env.value.value
            }
          }

          resources {
            limits {
              cpu    = var.historical_limits_cpu
              memory = var.historical_limits_memory
            }
            requests {
              cpu    = var.historical_requests_cpu
              memory = var.historical_requests_memory
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
