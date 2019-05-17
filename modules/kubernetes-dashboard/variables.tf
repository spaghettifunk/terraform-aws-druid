variable "name" {
  type        = "string"
  description = "Name of the Kubernetes Dashboard helm chart"
}

variable "namespace" {
  type        = "string"
  description = "Namespace name where the Kuberentes Dashboard service will be deployed in Kubernetes"
}

variable "version" {
  type        = "string"
  description = "Kubernetes Dashboard helm chart version"
  default     = "1.4.0"
}
