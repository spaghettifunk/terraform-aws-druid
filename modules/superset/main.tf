resource "helm_release" "superset" {
  name      = "${var.name}"
  namespace = "${var.namespace}"
  chart     = "stable/superset"
  version   = "${var.version}"

  set {
    name  = "persistence.enabled"
    value = "true"
  }
}
