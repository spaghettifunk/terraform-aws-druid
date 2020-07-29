resource "kubernetes_service" "broker_cs" {
  metadata {
    name      = "broker-cs"
    namespace = var.namespace
    labels    = local.broker_labels
  }
  spec {
    selector = local.broker_labels
    port {
      name = "broker"
      port = 8082
    }
  }
}

resource "kubernetes_deployment" "broker" {
  metadata {
    name      = "broker"
    namespace = var.namespace
    labels    = local.broker_labels
  }
  spec {
    replicas = var.broker_replicas
    selector {
      match_labels = local.broker_labels
    }
    template {
      metadata {
        labels = local.broker_labels
      }
      spec {
        container {
          name              = "broker"
          image             = local.druid_image
          image_pull_policy = "Always"
          port {
            name           = "broker"
            container_port = 8082
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
            for_each = local.broker_env_variables
            content {
              name  = env.value.name
              value = env.value.value
            }
          }
          resources {
            limits {
              cpu    = var.broker_limits_cpu
              memory = var.broker_limits_memory
            }
            requests {
              cpu    = var.broker_requests_cpu
              memory = var.broker_requests_memory
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
          security_context {
            capabilities {
              add = ["IPC_LOCK"]
            }
          }
        }
        dynamic "toleration" {
          for_each = [for t in var.broker_tolerations : {
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
        volume {
          name = "druid-secret"
          secret {
            secret_name = "druid-secret"
          }
        }
        volume {
          name = "data"
        }
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["broker"]
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
