locals {
  druid_image      = "${format("%s/%s:%s", var.druid_image_registry, var.druid_image_repository, var.druid_image_tag)}"
  postgres_url     = var.postgres_host
  zookeeper_server = var.zookeeper_host

  broker_limits = object({
    memory = var.broker_limits_memory
    cpu    = var.broker_limits_cpu
  })

  broker_requests = object({
    memory = var.broker_requests_memory
    cpu    = var.broker_requests_cpu
  })

  coordinator_limits = object({
    memory = var.coordinator_limits_memory
    cpu    = var.coordinator_limits_cpu
  })

  coordinator_requests = object({
    memory = var.coordinator_requests_memory
    cpu    = var.coordinator_requests_cpu
  })

  historical_limits = object({
    memory = var.historical_limits_memory
    cpu    = var.historical_limits_cpu
  })

  historical_requests = object({
    memory = var.historical_requests_memory
    cpu    = var.historical_requests_cpu
  })

  middlemanager_limits = object({
    memory = var.middlemanager_limits_memory
    cpu    = var.middlemanager_limits_cpu
  })

  middlemanager_requests = object({
    memory = var.middlemanager_requests_memory
    cpu    = var.middlemanager_requests_cpu
  })

  overlord_limits = object({
    memory = var.overlord_limits_memory
    cpu    = var.overlord_limits_cpu
  })

  overlord_requests = object({
    memory = var.overlord_requests_memory
    cpu    = var.overlord_requests_cpu
  })

  router_limits = object({
    memory = var.router_limits_memory
    cpu    = var.router_limits_cpu
  })

  router_requests = object({
    memory = var.router_requests_memory
    cpu    = var.router_requests_cpu
  })
}
