resource "kubernetes_config_map" "common_config" {
  metadata {
    name      = "druid-common-config"
    namespace = var.namespace
  }

  data = {
    POSTGRES_URL      = local.postgres_url
    POSTGRES_PORT     = var.postgres_port
    POSTGRES_USER     = var.postgres_username
    POSTGRES_PASSWORD = var.postgres_password
    POSTGRES_DB       = var.postgres_db
    ZOOKEEPER_SERVER  = local.zookeeper_server
    JVM_PEONS_ARGS    = format("-Daws.region=%s", var.aws_region)
  }
}
