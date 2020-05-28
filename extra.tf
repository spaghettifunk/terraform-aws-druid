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
