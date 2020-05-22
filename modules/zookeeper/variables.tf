variable "namespace" {
  type        = string
  description = "zookeeper namespace where the resource will be installed"
  default     = "zookeeper-druid"
}

variable "replicas" {
  type        = string
  description = "number of replicas used for the resource. For HA use an odd number"
  default     = "3"
}
