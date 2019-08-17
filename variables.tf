variable "namespace" {
  type        = "string"
  description = "Namespace where Druid will be deployed"
  default     = "druid"
}

variable "aws_access_key" {
  type        = "string"
  description = "AWS Access Key value. Permissions needed for S3"
}

variable "aws_secret_key" {
  type        = "string"
  description = "AWS Secret Key value. Permissions needed for S3"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
}

variable "aws_bucket_storage" {
  type        = "string"
  description = "S3 bucket for storing the segments"
}

variable "aws_bucket_index" {
  type        = "string"
  description = "S3 bucket for storing the indexes"
}

// Postgres variables
variable "postgres_db" {
  type        = "string"
  description = "Postgress Database name for Druid"
  default     = "druid"
}

variable "postgres_user" {
  type        = "string"
  description = "Postgres username for accessing the DB"
  default     = "druid"
}

variable "postgres_password" {
  type        = "string"
  description = "Postgress Password of the user"
  default     = "druid"
}

// Druid variables
variable "druid_image" {
  type        = "string"
  description = "Docker image of Druid. Example: repo/druid"
}

variable "druid_tag" {
  type        = "string"
  description = "Docker image tag"
  default     = "latest"
}

variable "broker_replicas" {
  type        = "number"
  description = "Number of replicas for the Broker service"
  default     = 1
}

variable "coordinator_replicas" {
  type        = "number"
  description = "Number of replicas for the Coordinator service"
  default     = 1
}

variable "historical_replicas" {
  type        = "number"
  description = "Number of replicas for the Historical service"
  default     = 1
}

variable "middlemanager_replicas" {
  type        = "number"
  description = "Number of replicas for the Middlemanager service"
  default     = 2
}

variable "overlord_replicas" {
  type        = "number"
  description = "Number of replicas for the Overlord service"
  default     = 1
}

variable "router_replicas" {
  type        = "number"
  description = "Number of replicas for the Router service"
  default     = 1
}

variable "zookeeper_replicas" {
  type        = "number"
  description = "Number of replicas for the Zookeeper service"
  default     = 3
}
