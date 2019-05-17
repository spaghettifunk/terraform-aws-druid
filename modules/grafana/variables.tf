variable "name" {
  type        = "string"
  description = "Name of the Grafana helm chart"
}

variable "namespace" {
  type        = "string"
  description = "Namespace name of the Grafana helm chart"
}

variable "version" {
  type        = "string"
  description = "Name of the Grafana helm chart"
  default     = "3.3.1"
}
