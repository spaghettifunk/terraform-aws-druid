resource "kubernetes_config_map" "common_config" {
  metadata {
    name      = "druid-common-config"
    namespace = var.namespace
  }

  data = {
    POSTGRES_URL      = local.postgres_url
    POSTGRES_DB       = var.db_name
    POSTGRES_PORT     = var.db_port
    POSTGRES_PASSWORD = var.db_password
    POSTGRES_USER     = var.db_username
    ZOOKEEPER_SERVER  = local.zookeeper_server
    JVM_PEONS_ARGS    = format("-Daws.region=%s", var.aws_region)
  }
}
