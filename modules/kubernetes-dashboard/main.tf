resource "helm_release" "kubernetes-dashboard" {
  name      = "${var.name}"
  namespace = "${var.namespace}"
  chart     = "stable/kubernetes-dashboard"
  version   = "${var.version}"

  set {
    name  = "fullnameOverride"
    value = "kubernetes-dashboard"
  }

  set {
    name  = "rbac.clusterAdminRole"
    value = "true"
  }

  # Set a token expiration in 12h
  set {
    name  = "extraArgs"
    value = "{--token-ttl=43200}"
  }
}
