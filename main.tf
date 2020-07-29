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

  namespace   = kubernetes_namespace.druid.metadata.0.name
  druid_image = local.druid_image

  broker_replicas           = var.broker_replicas
  broker_tolerations        = var.broker_tolerations
  broker_requests           = local.broker_requests
  broker_limits             = local.broker_limits
  coordinator_replicas      = var.coordinator_replicas
  coordinator_tolerations   = var.coordinator_tolerations
  coordinator_requests      = local.coordinator_requests
  coordinator_limits        = local.coordinator_limits
  historical_replicas       = var.historical_replicas
  historical_tolerations    = var.historical_tolerations
  historical_requests       = local.historical_requests
  historical_limits         = local.historical_limits
  middlemanager_replicas    = var.middlemanager_replicas
  middlemanager_tolerations = var.middlemanager_tolerations
  middlemanager_requests    = local.middlemanager_requests
  middlemanager_limits      = local.middlemanager_limits
  overlord_replicas         = var.overlord_replicas
  overlord_tolerations      = var.overlord_tolerations
  overlord_requests         = local.overlord_requests
  overlord_limits           = local.overlord_limits
  router_replicas           = var.router_replicas
  router_tolerations        = var.router_tolerations
  router_requests           = local.router_requests
  router_limits             = local.router_limits
  
  enable_brokers_ingress      = var.enable_brokers_ingress
  brokers_annotations_ingress = var.brokers_annotations_ingress
  brokers_host                = var.brokers_host
  enable_router_ingress       = var.enable_router_ingress
  router_annotations_ingress  = var.router_annotations_ingress
  router_host                 = var.router_host
}
