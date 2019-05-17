resource "helm_release" "cluster-autoscaler" {
  name      = "${var.name}"
  namespace = "${var.namespace}"
  chart     = "stable/cluster-autoscaler"
  version   = "${var.version}"

  set {
    name  = "autoDiscovery.clusterName"
    value = "${var.cluster_name}"
  }

  set {
    name  = "sslCertPath"
    value = "/etc/kubernetes/pki/ca.crt"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "awsRegion"
    value = "${var.aws_region}"
  }
}
