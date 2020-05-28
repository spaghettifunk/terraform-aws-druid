variable "enable" {
  type        = bool
  description = "enable the creation of this resource"
  default     = true
}

variable "namespace" {
  type        = string
  description = "postgres namespace where the resource will be installed"
  default     = "druid"
}

variable "config_map_name" {
  type        = string
  description = "name of the configmap where the postgres ENV are set"
  default     = "druid-common-config"
}

