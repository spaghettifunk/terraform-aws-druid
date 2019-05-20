variable "instance_type" {
  type        = "string"
  description = "Type of EC2 instance used to create worker nodes in Kubernetes"
}

variable "private_subnets" {
  type        = "list"
  description = "List of private subnet IDs where the worker nodes will be deployed"
}

variable "public_subnets" {
  type        = "list"
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

variable "desired_capacity" {
  type        = "string"
  default     = "3"
  description = "Desired number of servers"
}

variable "min_size" {
  type        = "string"
  default     = "2"
  description = "Minimun number of servers"
}

variable "max_size" {
  type        = "string"
  default     = "6"
  description = "Maximun number of servers"
}
