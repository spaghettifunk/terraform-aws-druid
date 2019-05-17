resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "${kubernetes_service_account.tiller.metadata.0.name}"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.tiller.metadata.0.name}"
    namespace = "${kubernetes_service_account.tiller.metadata.0.namespace}"
  }

  # Give a few seconds to the applications deployed with tiller to be uninstalled
  provisioner "local-exec" {
    when    = "destroy"
    command = "sleep 120"
  }
}
