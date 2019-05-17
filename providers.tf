provider "aws" {
  version = "= 2.6"
  region  = "${var.aws_region}"
}

provider "null" {
  version = "= 2.1"
}

provider "template" {
  version = "= 2.1"
}

provider "local" {
  version = "= 1.2"
}

data "aws_eks_cluster" "cluster" {
  name = "${module.eks.cluster_name}"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "${module.eks.cluster_name}"
}

provider "kubernetes" {
  version                = "= 1.6.2"
  host                   = "${data.aws_eks_cluster.cluster.endpoint}"
  cluster_ca_certificate = "${base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)}"
  token                  = "${data.aws_eks_cluster_auth.cluster.token}"
  load_config_file       = false
}

# Must be here in order to avoid issues
provider "helm" {
  version = "= 0.9.1"

  debug          = true
  install_tiller = true

  service_account = "${module.helm-tiller.name}"
  namespace       = "${module.helm-tiller.namespace}"

  # Don't change the version in order to match with cli 
  tiller_image = "gcr.io/kubernetes-helm/tiller:v2.11.0"
  home         = "/root/.helm"

  kubernetes {
    config_path = "${module.eks.kubeconfig_filename}"
  }
}
