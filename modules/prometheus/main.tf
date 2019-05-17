resource "helm_release" "prometheus" {
  name      = "${var.name}"
  namespace = "${var.namespace}"
  chart     = "stable/prometheus"
  version   = "${var.version}"
}
