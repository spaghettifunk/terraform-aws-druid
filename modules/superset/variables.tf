variable "name" {
  type        = "string"
  description = "Name of the Superset helm chart"
}

variable "namespace" {
  type        = "string"
  description = "Namespace name where Superset will be deployed"
}

variable "version" {
  type        = "string"
  description = "Superset helm chart version"
  default     = "1.1.5"
}
