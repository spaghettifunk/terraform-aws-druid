locals {

  druid_image      = "${format("%s/%s:%s", var.druid_image_registry, var.druid_image_repository, var.druid_image_tag)}"
  postgres_url     = var.postgres_host
  zookeeper_server = var.zookeeper_host

  # labels
  broker_labels        = { app = "broker" }
  overlord_labels      = { app = "overlord" }
  middlemanager_labels = { app = "middlemanager" }
  historical_labels    = { app = "historical" }
  coordinator_labels   = { app = "coordinator" }
  router_labels        = { app = "router" }

  # JVM settings
  common_JVM = "-Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"

  broker_env_variables = [
    {
      name  = "DRUID_SERVICE_PORT"
      value = var.broker_port
    },
    {
      name  = "DRUID_SERVICE"
      value = "broker"
    },
    {
      name  = "DRUID_JVM_ARGS"
      value = format("-server -Xms%s -Xmx%s -XX:+UseG1GC", replace(var.broker_limits_memory, "i", ""), replace(var.broker_limits_memory, "i", ""))
    }
  ]

  overlord_env_variables = [
    {
      name  = "DRUID_SERVICE_PORT"
      value = var.overlord_port
    },
    {
      name  = "DRUID_SERVICE"
      value = "overlord"
    },
    {
      name  = "DRUID_JVM_ARGS"
      value = format("-server -Xms%s -Xmx%s", replace(var.overlord_limits_memory, "i", ""), replace(var.overlord_limits_memory, "i", ""))
    }
  ]

  middlemanager_env_variables = [
    {
      name  = "DRUID_SERVICE_PORT"
      value = var.middlemanager_port
    },
    {
      name  = "DRUID_SERVICE"
      value = "middleManager"
    },
    {
      name  = "DRUID_JVM_ARGS"
      value = format("-server -Xms%s -Xmx%s", replace(var.middlemanager_limits_memory, "i", ""), replace(var.middlemanager_limits_memory, "i", ""))
    }
  ]

  historical_env_variables = [
    {
      name  = "DRUID_SERVICE_PORT"
      value = var.historical_port
    },
    {
      name  = "DRUID_SERVICE"
      value = "historical"
    },
    {
      name  = "DRUID_JVM_ARGS"
      value = format("-server -Xms%s -Xmx%s", replace(var.historical_limits_memory, "i", ""), replace(var.historical_limits_memory, "i", ""))
    }
  ]

  coordinator_env_variables = [
    {
      name  = "DRUID_SERVICE_PORT"
      value = var.coordinator_port
    },
    {
      name  = "DRUID_SERVICE"
      value = "coordinator"
    },
    {
      name  = "DRUID_JVM_ARGS"
      value = format("-server -Xms%s -Xmx%s", replace(var.coordinator_limits_memory, "i", ""), replace(var.coordinator_limits_memory, "i", ""))
    }
  ]

  router_env_variables = [
    {
      name  = "DRUID_SERVICE_PORT"
      value = var.router_port
    },
    {
      name  = "DRUID_SERVICE"
      value = "router"
    },
    {
      name  = "DRUID_JVM_ARGS"
      value = format("-server -Xms%s -Xmx%s", replace(var.router_limits_memory, "i", ""), replace(var.router_limits_memory, "i", ""))
    }
  ]
}
