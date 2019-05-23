variable "name" {
  type        = "string"
  description = "Name of the kube-state-metrics helm chart"
}

variable "namespace" {
  type        = "string"
  description = "Namespace name of the kube-state-metrics helm chart"
}

variable "chart_version" {
  type        = "string"
  description = "Version of the kube-state-metrics helm chart"
  default     = "1.6.2"
}

variable "application_version" {
  type        = "string"
  description = "Version of the kube-state-metrics application"
  default     = "1.6.0"
}
