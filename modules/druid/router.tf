resource "kubernetes_service" "router_hs" {
  metadata {
    name      = "router-hs"
    namespace = var.namespace

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
    namespace = var.namespace

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
    namespace = var.namespace

    labels = {
      app = "router"
    }
  }

  spec {
    replicas = var.router_replicas

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
        container {
          name  = "router"
          image = var.druid_image

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
            value = "-server -Xms512m -Xmx512m -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"
          }

          resources {
            limits {
              memory = "512Mi"
              cpu    = "128m"
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
          for_each = [for t in var.tolerations_router : {
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
