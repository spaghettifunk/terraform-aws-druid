variable "name" {
  type        = "string"
  description = "Name of service account that will be used by Tiller"
}

variable "namespace" {
  type        = "string"
  description = "Namespace name where the service account of Tiller will operate from"
}
