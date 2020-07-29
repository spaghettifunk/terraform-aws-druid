locals {

  druid_image      = "${format("%s/%s:%s", var.druid_image_registry, var.druid_image_repository, var.druid_image_tag)}"
  postgres_url     = var.postgres_host
  zookeeper_server = var.zookeeper_host

  broker_labels = {
    app = "broker"
  }
  broker_env_variables = [
    {
      name  = "DRUID_SERVICE_PORT"
      value = "8082"
    },
    {
      name  = "DRUID_SERVICE"
      value = "broker"
    },
    {
      name  = "DRUID_JVM_ARGS"
      value = "-server -Xms8G -Xmx8G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -XX:+UseG1GC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"
    }
  ]

  overlord_labels = {
    app = "overlord"
  }
  overlord_env_variables = [
    {
      name  = "DRUID_SERVICE_PORT"
      value = "8090"
    },
    {
      name  = "DRUID_SERVICE"
      value = "overlord"
    },
    {
      name  = "DRUID_JVM_ARGS"
      value = "-server -Xms2G -Xmx2G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"
    }
  ]

  middlemanager_labels = {
    app = "middlemanager"
  }
  middlemanager_env_variables = [
    {
      name  = "DRUID_SERVICE_PORT"
      value = "8084"
    },
    {
      name  = "DRUID_SERVICE"
      value = "middleManager"
    },
    {
      name  = "DRUID_JVM_ARGS"
      value = "-server -Xms8G -Xmx8G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"
    }
  ]

  historical_labels = {
    app = "historical"
  }
  historical_env_variables = [
    {
      name  = "DRUID_SERVICE_PORT"
      value = "8083"
    },
    {
      name  = "DRUID_SERVICE"
      value = "historical"
    },
    {
      name  = "DRUID_JVM_ARGS"
      value = "-server -Xms8G -Xmx8G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -XX:+UseConcMarkSweepGC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"
    }
  ]

  coordinator_labels = {
    app = "coordinator"
  }
  coordinator_env_variables = [
    {
      name  = "DRUID_SERVICE_PORT"
      value = "8081"
    },
    {
      name  = "DRUID_SERVICE"
      value = "coordinator"
    },
    {
      name  = "DRUID_JVM_ARGS"
      value = "-server -Xm2G -Xmx2G -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -Dderby.stream.error.file=var/druid/derby.log"
    }
  ]

  router_labels = {
    app = "router"
  }
  router_env_variables = [
    {
      name  = "DRUID_SERVICE_PORT"
      value = "8888"
    },
    {
      name  = "DRUID_SERVICE"
      value = "router"
    },
    {
      name  = "DRUID_JVM_ARGS"
      value = "-server -Xms512m -Xmx512m -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"
    }
  ]
}

