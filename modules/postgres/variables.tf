variable "namespace" {
  type        = string
  description = "postgres namespace where the resource will be installed"
  default     = "postgres-druid"
}

variable "db_name" {
  type        = string
  description = "name of the postgres database"
  default     = "druid"
}

variable "db_username" {
  type        = string
  description = "username for the user in the postgres database"
  default     = "druid"
}

variable "db_password" {
  type        = string
  description = "password of the user in the postgres database"
  default     = "druid"
}

