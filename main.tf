resource "kubernetes_namespace" "druid" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "common_config" {
  metadata {
    name      = "druid-common-config"
    namespace = kubernetes_namespace.druid.metadata.0.name
  }

  data = {
    POSTGRES_URL      = local.postgres_url
    POSTGRES_PORT     = var.postgres_port
    POSTGRES_USER     = var.postgres_user
    POSTGRES_PASSWORD = var.postgres_password
    POSTGRES_DB       = var.postgres_db
    ZOOKEEPER_SERVER  = local.zookeeper_server
    JVM_PEONS_ARGS    = format("-Daws.region=%s", var.aws_region)
  }
}

module "postgres" {
  source = "./modules/postgres"

  enable          = var.create_postgres
  namespace       = var.postgres_namespace
  config_map_name = "druid-common-config"
}

module "zookeeper" {
  source = "./modules/zookeeper"

  enable    = var.create_zookeeper
  namespace = var.zookeeper_namespace
  replicas  = var.zookeeper_replicas
}
