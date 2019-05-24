resource "helm_release" "kube-state-metrics" {
  name      = "${var.name}"
  namespace = "${var.namespace}"
  chart     = "stable/kube-state-metrics"
  version   = "${var.chart_version}"

  set {
    name = "rbac.create"
    value = "true"
  }
}
