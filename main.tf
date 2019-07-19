module "vpc" {
  source = "./modules/vpc"
  azs    = "${var.aws_azs}"

  tags = {
    KubernetesCluster                 = "${terraform.workspace}-eks"
    Terraform                         = "true"
    Environment                       = "${terraform.workspace}-vpc"
  }
}

module "ssh_key" {
  source   = "./modules/key"
  key_name = "${terraform.workspace}-key-cluster"
}

module "eks" {
  source    = "./modules/eks"
  name      = "eks-admin"
  namespace = "kube-system"

  vpc_id          = "${module.vpc.vpc_id}"
  cluster_name    = "${terraform.workspace}-eks"
  public_subnets  = "${module.vpc.public_subnets}"
  private_subnets = "${module.vpc.private_subnets}"
  key_name        = "${module.ssh_key.key_name}"
  instance_type   = "${var.instance_type}"

  tags = {
    KubernetesCluster                 = "${terraform.workspace}-eks"
    "kubernetes.io/role/internal-elb" = ""
    Terraform                         = "true"
    Environment                       = "${terraform.workspace}-vpc"
  }
}

module "helm-tiller" {
  source    = "./modules/helm-tiller"
  name      = "tiller"
  namespace = "kube-system"
}

module "kubernetes-dashboard" {
  source    = "./modules/kubernetes-dashboard"
  name      = "kubernetes-dashboard"
  namespace = "kube-system"
}

module "cluster-autoscaler" {
  source    = "./modules/cluster-autoscaler"
  name      = "cluster-autoscaler"
  namespace = "kube-system"

  cluster_name = "${module.eks.cluster_name}"
  aws_region   = "${var.aws_region}"
}

module "prometheus" {
  source    = "./modules/prometheus"
  name      = "prometheus"
  namespace = "kube-system"
}

module "grafana" {
  source    = "./modules/grafana"
  name      = "grafana"
  namespace = "kube-system"
}

module "superset" {
  source    = "./modules/superset"
  name      = "superset"
  namespace = "superset"
}

module "kube-state-metrics" {
  source    = "./modules/kube-state-metrics"
  name      = "kube-state-metrics"
  namespace = "kube-system"
}
