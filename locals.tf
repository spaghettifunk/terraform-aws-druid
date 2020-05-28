locals {
  druid_image      = "${format("%s/%s:%s", var.druid_image_registry, var.druid_image_repository, var.druid_image_tag)}"
  postgres_url     = var.postgres_host
  zookeeper_server = var.zookeeper_host
}
