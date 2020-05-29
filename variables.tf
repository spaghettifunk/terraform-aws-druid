variable "namespace" {
  type        = string
  description = "Namespace where Druid will be deployed"
  default     = "druid"
}

// Druid variables
variable "druid_image_registry" {
  type        = string
  description = "Docker registry used to fetch the Apache Druid image"
  default     = "davideberdin"
}

variable "druid_image_repository" {
  type        = string
  description = "Docker image of Apache Druid compatible for this module"
  default     = "apache-druid"
}

variable "druid_image_tag" {
  type        = string
  description = "Docker image tag"
  default     = "0.18.1"
}

variable "broker_replicas" {
  type        = number
  description = "Number of replicas for the Broker service"
  default     = 3
}

variable "tolerations_broker" {
  description = "toleration to apply to the deployment of the broker"
  type = list(object({
    effect             = string
    key                = string
    operator           = string
    toleration_seconds = string
    value              = string
  }))
  default = []
}

variable "coordinator_replicas" {
  type        = number
  description = "Number of replicas for the Coordinator service"
  default     = 1
}

variable "tolerations_coordinator" {
  description = "toleration to apply to the deployment of the coordinator"
  type = list(object({
    effect             = string
    key                = string
    operator           = string
    toleration_seconds = string
    value              = string
  }))
  default = []
}

variable "historical_replicas" {
  type        = number
  description = "Number of replicas for the Historical service"
  default     = 1
}

variable "tolerations_historical" {
  description = "toleration to apply to the deployment of the historical"
  type = list(object({
    effect             = string
    key                = string
    operator           = string
    toleration_seconds = string
    value              = string
  }))
  default = []
}

variable "middlemanager_replicas" {
  type        = number
  description = "Number of replicas for the Middlemanager service"
  default     = 1
}

variable "tolerations_middlemanager" {
  description = "toleration to apply to the deployment of the middlemanager"
  type = list(object({
    effect             = string
    key                = string
    operator           = string
    toleration_seconds = string
    value              = string
  }))
  default = []
}

variable "overlord_replicas" {
  type        = number
  description = "Number of replicas for the Overlord service"
  default     = 1
}

variable "tolerations_overlord" {
  description = "toleration to apply to the deployment of the overlord"
  type = list(object({
    effect             = string
    key                = string
    operator           = string
    toleration_seconds = string
    value              = string
  }))
  default = []
}

variable "router_replicas" {
  type        = number
  description = "Number of replicas for the Router service"
  default     = 1
}

variable "tolerations_router" {
  description = "toleration to apply to the deployment of the router"
  type = list(object({
    effect             = string
    key                = string
    operator           = string
    toleration_seconds = string
    value              = string
  }))
  default = []
}

// Zookeeper variables
variable "create_zookeeper" {
  description = "Controls if Zookeeper resources should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "zookeeper_namespace" {
  type        = string
  description = "namespace where to deploy the zookeeper resource"
  default     = "zk-druid"
}

variable "zookeeper_host" {
  type        = string
  description = "Zookeeper hostname for Druid"
  default     = "zk-cs.zk-druid.svc.cluster.local"
}

variable "zookeeper_replicas" {
  type        = number
  description = "Number of replicas for the Zookeeper service"
  default     = 3
}

// Postgres variables
variable "create_postgres" {
  type        = bool
  description = "Controls if Postgres database resources should be created (it affects almost all resources)"
  default     = true
}

variable "postgres_namespace" {
  type        = string
  description = "namespace where to deploy the postgres resource"
  default     = "druid"
}

variable "postgres_db" {
  type        = string
  description = "Postgress Database name for Druid"
  default     = "druid"
}

variable "postgres_host" {
  type        = string
  description = "Postgress Database hostname for Druid"
  default     = "postgres-cs.druid.svc.cluster.local"
}

variable "postgres_port" {
  type        = string
  description = "Postgress Database port for Druid"
  default     = "5432"
}

variable "postgres_user" {
  type        = string
  description = "Postgres username for accessing the DB"
  default     = "druid"
}

variable "postgres_password" {
  type        = string
  description = "Postgress Password of the user"
  default     = "druid"
}

// AWS variables
variable "aws_access_key" {
  type        = string
  description = "AWS Access Key value. Permissions needed for S3"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key value. Permissions needed for S3"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_bucket_storage" {
  type        = string
  description = "S3 bucket for storing the segments"
}

variable "aws_bucket_index" {
  type        = string
  description = "S3 bucket for storing the indexes"
}
