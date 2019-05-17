output "kubeconfig_filename" {
  value = "${module.eks-terraform.kubeconfig_filename}"
}

output "kubeconfig" {
  value = "${module.eks-terraform.kubeconfig}"
}

output "cluster_endpoint" {
  value = "${module.eks-terraform.cluster_endpoint}"
}

output "worker_security_group_id" {
  value = "${module.eks-terraform.worker_security_group_id}"
}

output "cluster_name" {
  value = "${module.eks-terraform.cluster_id}"
}

output "worker_iam_role_arn" {
  value = "${module.eks-terraform.worker_iam_role_arn}"
}
