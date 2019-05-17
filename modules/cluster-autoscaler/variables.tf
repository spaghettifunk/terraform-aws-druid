variable "name" {
  type        = "string"
  description = "Name of the Cluster Autoscaler helm chart"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region where the Autoscaler will operate on to spin up EC2 instances"
}

variable "namespace" {
  type        = "string"
  description = "Namespace name where the Cluster Autoscale service will be deployed in Kubernetes"
}

variable "cluster_name" {
  type        = "string"
  description = "EKS Cluster name in which the Cluster Autoscale helm chart will be installed"
}

variable "version" {
  type        = "string"
  description = "Cluster Autoscale helm chart version"
  default     = "0.12.1"
}
