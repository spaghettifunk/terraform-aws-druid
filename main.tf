// Create namespace
resource "kubernetes_namespace" "druid" {
  metadata {
    name = "${var.namespace}"
  }
}

// Secrets
resource "null_resource" "druid_seret" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.druid_secret.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.druid_seret.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.druid_seret.rendered}\nEOF"
  }
}

// Configmaps
resource "null_resource" "configmap_postgres" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.configmap_postgres.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.configmap_postgres.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.configmap_postgres.rendered}\nEOF"
  }
}

// Service Broker
resource "null_resource" "service_broker" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.service_broker.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.service_broker.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.service_broker.rendered}\nEOF"
  }
}

// Service Coordinator
resource "null_resource" "service_coordinator" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.service_coordinator.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.service_coordinator.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.service_coordinator.rendered}\nEOF"
  }
}

// Service Historical
resource "null_resource" "service_historical" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.service_historical.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.service_historical.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.service_historical.rendered}\nEOF"
  }
}

// Service Middlemanager
resource "null_resource" "service_middlemanager" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.service_middlemanager.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.service_middlemanager.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.service_middlemanager.rendered}\nEOF"
  }
}

// Service Overlord
resource "null_resource" "service_overlord" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.service_overlord.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.service_overlord.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.service_overlord.rendered}\nEOF"
  }
}

// Service Router
resource "null_resource" "service_router" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.service_router.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.service_router.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.service_router.rendered}\nEOF"
  }
}

// Service Postgres
resource "null_resource" "service_postgres" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.service_postgres.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.service_postgres.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.service_postgres.rendered}\nEOF"
  }
}

// Service Zookeeper
resource "null_resource" "service_zookeeper" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.service_zookeeper.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.service_zookeeper.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.service_zookeeper.rendered}\nEOF"
  }
}

// Deployment Broker
resource "null_resource" "deployment_broker" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.deployment_broker.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.deployment_broker.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.deployment_broker.rendered}\nEOF"
  }
}

// Deployment Coordinator
resource "null_resource" "deployment_coordinator" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.deployment_coordinator.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.deployment_coordinator.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.deployment_coordinator.rendered}\nEOF"
  }
}

// Deployment Historical
resource "null_resource" "deployment_historical" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.deployment_historical.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.deployment_historical.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.deployment_historical.rendered}\nEOF"
  }
}

// Deployment Overlord
resource "null_resource" "deployment_overlord" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.deployment_overlord.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.deployment_overlord.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.deployment_overlord.rendered}\nEOF"
  }
}

// Deployment Router
resource "null_resource" "deployment_router" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.deployment_router.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.deployment_router.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.deployment_router.rendered}\nEOF"
  }
}

// Deployment Zookeeper
resource "null_resource" "deployment_zookeeper" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.deployment_zookeeper.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.deployment_zookeeper.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.deployment_zookeeper.rendered}\nEOF"
  }
}

// Deployment Postgres
resource "null_resource" "deployment_postgres" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.deployment_postgres.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.deployment_postgres.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = "kubectl delete -f -<<EOF\n${data.template_file.deployment_postgres.rendered}\nEOF"
  }
}
