locals {
  druid_image      = "${format("%s/%s:%s", var.druid_image_registry, var.druid_image_repository, var.druid_image_tag)}"
  postgres_url     = "${format("%s:%s@%s:%s/%s", var.postgres_user, var.postgres_password, var.postgres_host, var.postgres_port, var.postgres_db)}"
  zookeeper_server = var.zookeeper_host
}
