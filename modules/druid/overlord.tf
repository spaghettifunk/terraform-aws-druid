resource "kubernetes_service" "overlord_hs" {
  metadata {
    name      = "overlord-hs"
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

    cluster_ip = "None"
  }
}

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

    labels = {
      app = "overlord"
    }
  }

  spec {
    replicas = var.overlord_replicas

    selector {
      match_labels = {
        app = "overlord"
      }
    }

    template {
      metadata {
        labels = {
          app = "overlord"
        }
      }

      spec {
        container {
          name  = "overlord"
          image = var.druid_image

          port {
            name           = "overlord"
            container_port = 8090
          }

          env_from {
            config_map_ref {
              name = "druid-common-config"
            }
          }

          env {
            name  = "DRUID_SERVICE_PORT"
            value = "8090"
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
            value = "overlord"
          }

          env {
            name  = "DRUID_JVM_ARGS"
            value = "-server -Xms1G -Xmx1G -XX:MaxDirectMemorySize=2G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"
          }

          env_from {
            secret_ref {
              name = "druid-secret"
            }
          }

          resources {
            limits {
              cpu    = "512m"
              memory = "2Gi"
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
          for_each = [for t in var.tolerations_overlord : {
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

          pod_affinity {
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
