resource "kubernetes_service" "overlord_cs" {
  metadata {
    name      = "overlord-cs"
    namespace = var.namespace

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
    namespace = var.namespace
    labels    = local.overlord_labels
  }

  spec {
    replicas = var.overlord_replicas
    selector {
      match_labels = local.overlord_labels
    }
    template {
      metadata {
        labels = local.overlord_labels
      }
      spec {
        container {
          name  = "overlord"
          image = local.druid_image
          image_pull_policy = "Always"

          port {
            name           = "overlord"
            container_port = 8090
          }

          env_from {
            secret_ref {
              name = "druid-secret"
            }
          }

          env_from {
            config_map_ref {
              name = "druid-common-config"
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
            for_each = local.overlord_env_variables
            content {
              name  = env.value.name
              value = env.value.value
            }
          }

          resources {
            limits {
              cpu    = var.overlord_limits_cpu
              memory = var.overlord_limits_memory
            }
            requests {
              cpu    = var.overlord_requests_cpu
              memory = var.overlord_requests_memory
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
          for_each = [for t in var.overlord_tolerations : {
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
                  values   = ["overlord"]
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
