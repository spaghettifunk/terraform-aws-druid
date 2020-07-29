resource "kubernetes_service" "router_cs" {
  metadata {
    name      = "router-cs"
    namespace = var.namespace
    labels    = local.router_labels
  }
  spec {
    port {
      name = "router"
      port = 8888
    }
    selector = local.router_labels
  }
}

resource "kubernetes_deployment" "router" {
  metadata {
    name      = "router"
    namespace = var.namespace
    labels    = local.router_labels
  }

  spec {
    replicas = var.router_replicas

    selector {
      match_labels = local.router_labels
    }

    template {
      metadata {
        labels = local.router_labels
      }

      spec {
        container {
          name              = "router"
          image             = local.druid_image
          image_pull_policy = "Always"

          port {
            name           = "router"
            container_port = 8888
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
            for_each = local.router_env_variables
            content {
              name  = env.value.name
              value = env.value.value
            }
          }

          resources {
            limits {
              cpu    = var.router_limits_cpu
              memory = var.router_limits_memory
            }
            requests {
              cpu    = var.router_requests_cpu
              memory = var.router_requests_memory
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
          for_each = [for t in var.router_tolerations : {
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

        termination_grace_period_seconds = 1800
      }
    }
  }
}

resource "kubernetes_ingress" "router" {
  count = var.enable_router_ingress ? 1 : 0

  metadata {
    name        = "router"
    namespace   = var.namespace
    annotations = var.router_annotations_ingress
  }

  spec {
    rule {
      host = var.router_host
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.router_cs.metadata.0.name
            service_port = kubernetes_service.router_cs.spec.0.port.0.port
          }
        }
      }
    }
  }
}
