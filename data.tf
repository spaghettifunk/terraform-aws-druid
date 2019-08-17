// AWS Secrets
data "template_file" "druid_secret" {
  template = "${file("${path.module}/templates/secrets/aws_credentials.yaml")}"

  vars = {
    namespace          = "${var.namespace}"
    aws_access_key     = "${var.aws_access_key}"
    aws_secret_key     = "${var.aws_secret_key}"
    aws_region         = "${var.aws_region}"
    aws_bucket_storage = "${var.aws_bucket_storage}"
    aws_bucket_index   = "${var.aws_bucket_index}"
  }
}

// Postgres Configmap
data "template_file" "configmap_postgres" {
  template = "${file("${path.module}/templates/configmap/postgres.yaml")}"

  vars = {
    namespace         = "${var.namespace}"
    postgres_db       = "${var.postgres_db}"
    postgres_user     = "${var.postgres_user}"
    postgres_password = "${var.postgres_password}"
  }
}

// Druid Services
data "template_file" "service_broker" {
  template = "${file("${path.module}/templates/services/broker.yaml")}"

  vars = {
    namespace = "${var.namespace}"
  }
}

data "template_file" "service_coordinator" {
  template = "${file("${path.module}/templates/services/coordinator.yaml")}"

  vars = {
    namespace = "${var.namespace}"
  }
}

data "template_file" "service_historical" {
  template = "${file("${path.module}/templates/services/historical.yaml")}"

  vars = {
    namespace = "${var.namespace}"
  }
}

data "template_file" "service_middlemanager" {
  template = "${file("${path.module}/templates/services/middlemanager.yaml")}"

  vars = {
    namespace = "${var.namespace}"
  }
}

data "template_file" "service_overlord" {
  template = "${file("${path.module}/templates/services/overlord.yaml")}"

  vars = {
    namespace = "${var.namespace}"
  }
}

data "template_file" "service_router" {
  template = "${file("${path.module}/templates/services/router.yaml")}"

  vars = {
    namespace = "${var.namespace}"
  }
}

data "template_file" "service_postgres" {
  template = "${file("${path.module}/templates/services/postgres.yaml")}"

  vars = {
    namespace = "${var.namespace}"
  }
}

data "template_file" "service_zookeeper" {
  template = "${file("${path.module}/templates/services/zookeeper.yaml")}"

  vars = {
    namespace = "${var.namespace}"
  }
}

// Druid Deployments
data "template_file" "deployment_broker" {
  template = "${file("${path.module}/templates/deployments/broker.yaml")}"

  vars = {
    namespace   = "${var.namespace}"
    replicas    = "${var.broker_replicas}"
    druid_image = "${var.druid_image}"
    druid_tag   = "${var.druid_tag}"
  }
}

data "template_file" "deployment_coordinator" {
  template = "${file("${path.module}/templates/deployments/coordinator.yaml")}"

  vars = {
    namespace   = "${var.namespace}"
    replicas    = "${var.coordinator_replicas}"
    druid_image = "${var.druid_image}"
    druid_tag   = "${var.druid_tag}"
  }
}

data "template_file" "deployment_historical" {
  template = "${file("${path.module}/templates/deployments/historical.yaml")}"

  vars = {
    namespace   = "${var.namespace}"
    replicas    = "${var.historical_replicas}"
    druid_image = "${var.druid_image}"
    druid_tag   = "${var.druid_tag}"
  }
}

data "template_file" "deployment_overlord" {
  template = "${file("${path.module}/templates/deployments/overlord.yaml")}"

  vars = {
    namespace   = "${var.namespace}"
    replicas    = "${var.overlord_replicas}"
    druid_image = "${var.druid_image}"
    druid_tag   = "${var.druid_tag}"
  }
}

data "template_file" "deployment_router" {
  template = "${file("${path.module}/templates/deployments/router.yaml")}"

  vars = {
    namespace   = "${var.namespace}"
    replicas    = "${var.router_replicas}"
    druid_image = "${var.druid_image}"
    druid_tag   = "${var.druid_tag}"
  }
}

data "template_file" "deployment_zookeeper" {
  template = "${file("${path.module}/templates/deployments/zookeeper.yaml")}"

  vars = {
    namespace = "${var.namespace}"
    replicas  = "${var.zookeeper_replicas}"
  }
}

data "template_file" "deployment_postgres" {
  template = "${file("${path.module}/templates/deployments/postgres.yaml")}"

  vars = {
    namespace = "${var.namespace}"
  }
}
