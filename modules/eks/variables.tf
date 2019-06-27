variable "instance_type" {
  type        = "string"
  description = "Type of EC2 instance used to create worker nodes in Kubernetes"
}

variable "private_subnets" {
  type = list(string)
  description = "List of private subnet IDs where the worker nodes will be deployed"
}

variable "public_subnets" {
  type = list(string)
  description = "List of public subnet IDs where the EKS master will be deployed"
}

variable "cluster_name" {
  type        = "string"
  description = "EKS cluster name"
}

variable "vpc_id" {
  type        = "string"
  description = "AWS VPC ID where the EKS cluster will be deployed"
}

variable "key_name" {
  type        = "string"
  description = "SSH Key name used to create the EC2 instances"
}

variable "tags" {
  type        = "map"
  description = "Key/value map object that represents the tags for the EKS cluster"
}

variable "name" {
  type        = "string"
  description = "EKS Service account name"
}

variable "namespace" {
  type        = "string"
  description = "Namespace name where the service account will be created on"
}

variable "general_worker_group" {
  type    = "map"
  default = {
    "name" = "general-purpose"
    "instance_type" = "m4.xlarge"
    "key_name" = "your-key"
    "asg_desired_capacity" = "2"
    "asg_min_size" = "1"
    "asg_max_size" = "4"
  }
}

variable "mo_worker_group" {
  type    = "map"
  default = {
    "name" = "memory-optimized"
    "instance_type" = "r5.xlarge"
    "key_name" = "your-key"
    "asg_desired_capacity" = "1"
    "asg_min_size" = "1"
    "asg_max_size" = "1"
  }
}
