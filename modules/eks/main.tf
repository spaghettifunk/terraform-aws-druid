module "eks-terraform" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "5.0.0"
  cluster_name = "${var.cluster_name}"

  # Deploy in all possible networks. EKS cannot be changed afterwards
  vpc_id  = "${var.vpc_id}"
  subnets = concat("${var.private_subnets}", "${var.public_subnets}")

  manage_aws_auth = true
  cluster_version = "1.12"

  worker_groups = [
   {
      name                 = "${var.general_worker_group["name"]}"
      instance_type        = "${var.general_worker_group["instance_type"]}"
      key_name             = "${var.key_name}"
      asg_desired_capacity = "${var.general_worker_group["asg_desired_capacity"]}"
      asg_min_size         = "${var.general_worker_group["asg_min_size"]}"
      asg_max_size         = "${var.general_worker_group["asg_max_size"]}"
      autoscaling_enabled  = true
      ebs_optimized = true

      # Workers are only deployed on the private networks for now      
      subnets = "${var.private_subnets}"

      tags = [
        {
          key  = "type"
          value = "general-purpose"
          propagate_at_launch = true
        }
      ]
    },
    {
      name                 = "${var.mo_worker_group["name"]}"
      instance_type        = "${var.mo_worker_group["instance_type"]}"
      key_name             = "${var.key_name}"
      asg_desired_capacity = "${var.mo_worker_group["asg_desired_capacity"]}"
      asg_min_size         = "${var.mo_worker_group["asg_min_size"]}"
      asg_max_size         = "${var.mo_worker_group["asg_max_size"]}"
      autoscaling_enabled  = true
      ebs_optimized = true

      # Workers are only deployed on the private networks for now      
      subnets = "${var.private_subnets}"
      tags = [
        {
          key  = "type"
          value = "memory-optimised"
          propagate_at_launch = true
        }
      ]
    }
  ]

  # Add ssh access
  worker_additional_security_group_ids = ["${aws_security_group.allow_workers_ssh.id}"]

  tags = "${var.tags}"
}

# Allow ssh access
resource "aws_security_group" "allow_workers_ssh" {
  name_prefix = "${var.cluster_name}"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a explicit dependency so that starts once it is ready
# It is required to be able to execute kubectl
resource "null_resource" "update_eks_config" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${module.eks-terraform.cluster_id}"
  }
}

resource "kubernetes_service_account" "eks-admin" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "eks-admin" {
  metadata {
    name = "${kubernetes_service_account.eks-admin.metadata.0.name}"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.eks-admin.metadata.0.name}"
    namespace = "${kubernetes_service_account.eks-admin.metadata.0.namespace}"
    api_group = ""
  }
}
