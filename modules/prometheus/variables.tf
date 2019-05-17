variable "name" {
  type        = "string"
  description = "Name of the Prometheus helm chart"
}

variable "namespace" {
  type        = "string"
  description = "Namespace name where Prometheus will be deployed"
}

variable "version" {
  type        = "string"
  description = "Prometheus helm chart version"
  default     = "8.10.3"
}
