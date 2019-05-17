resource "helm_release" "grafana" {
  name      = "${var.name}"
  namespace = "${var.namespace}"
  chart     = "stable/grafana"
  version   = "${var.version}"

  set {
    name  = "namespace"
    value = "${var.namespace}"
  }
}
