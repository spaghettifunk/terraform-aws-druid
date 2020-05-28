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

module "druid" {
  source = "./modules/druid"

  namespace                 = kubernetes_namespace.druid.metadata.0.name
  druid_image               = local.druid_image
  broker_replicas           = var.broker_replicas
  coordinator_replicas      = var.coordinator_replicas
  historical_replicas       = var.historical_replicas
  middlemanager_replicas    = var.middlemanager_replicas
  overlord_replicas         = var.overlord_replicas
  router_replicas           = var.router_replicas
  tolerations_broker        = var.tolerations_broker
  tolerations_coordinator   = var.tolerations_coordinator
  tolerations_historical    = var.tolerations_historical
  tolerations_middlemanager = var.tolerations_middlemanager
  tolerations_overlord      = var.tolerations_overlord
  tolerations_router        = var.tolerations_router
}
