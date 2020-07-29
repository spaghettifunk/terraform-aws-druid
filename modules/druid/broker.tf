resource "kubernetes_service" "broker_cs" {
  metadata {
    name      = "broker-cs"
    namespace = var.namespace

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
    namespace = var.namespace

    labels = {
      app = "broker"
    }
  }

  spec {
    replicas = var.broker_replicas
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
        container {
          name  = "broker"
          image = var.druid_image

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
            value = "-server -Xms8G -Xmx8G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -XX:+UseG1GC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"
          }

          resources {
            limits   = var.broker_limits
            requests = var.broker_requests
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

resource "kubernetes_ingress" "brokers" {
  count = var.enable_brokers_ingress ? 1 : 0

  metadata {
    name        = "brokers"
    namespace   = var.namespace
    annotations = var.brokers_annotations_ingress
  }

  spec {
    rule {
      host = var.brokers_host
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.broker_cs.metadata.0.name
            service_port = kubernetes_service.broker_cs.spec.0.port.0.port
          }
        }
      }
    }
  }
}
