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

// Broker
variable "broker_replicas" {
  type        = number
  description = "Number of replicas for the Broker service"
  default     = 3
}

variable "broker_requests_cpu" {
  type        = string
  description = "amount of cpu request for each broker"
  default     = "512m"
}

variable "broker_requests_memory" {
  type        = string
  description = "amount of memory request for each broker"
  default     = "8Gi"
}

variable "broker_limits_cpu" {
  type        = string
  description = "amount of cpu limits for each broker"
  default     = "512m"
}

variable "broker_limits_memory" {
  type        = string
  description = "amount of memory limits for each broker"
  default     = "8Gi"
}

variable "broker_tolerations" {
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

// Coordinator
variable "coordinator_replicas" {
  type        = number
  description = "Number of replicas for the Coordinator service"
  default     = 1
}

variable "coordinator_requests_cpu" {
  type        = string
  description = "amount of cpu request for each coordinator"
  default     = "256m"
}

variable "coordinator_requests_memory" {
  type        = string
  description = "amount of memory request for each coordinator"
  default     = "2Gi"
}

variable "coordinator_limits_cpu" {
  type        = string
  description = "amount of cpu limits for each coordinator"
  default     = "256m"
}

variable "coordinator_limits_memory" {
  type        = string
  description = "amount of memory limits for each coordinator"
  default     = "2Gi"
}

variable "coordinator_tolerations" {
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

// Historical
variable "historical_replicas" {
  type        = number
  description = "Number of replicas for the Historical service"
  default     = 1
}

variable "historical_requests_cpu" {
  type        = string
  description = "amount of cpu request for each historical"
  default     = "512m"
}

variable "historical_requests_memory" {
  type        = string
  description = "amount of memory request for each historical"
  default     = "8Gi"
}

variable "historical_limits_cpu" {
  type        = string
  description = "amount of cpu limits for each historical"
  default     = "512m"
}

variable "historical_limits_memory" {
  type        = string
  description = "amount of memory limits for each historical"
  default     = "8Gi"
}

variable "historical_tolerations" {
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

// Middlemanager
variable "middlemanager_replicas" {
  type        = number
  description = "Number of replicas for the Middlemanager service"
  default     = 1
}

variable "middlemanager_requests_cpu" {
  type        = string
  description = "amount of cpu request for each middlemanager"
  default     = "512m"
}

variable "middlemanager_requests_memory" {
  type        = string
  description = "amount of memory request for each middlemanager"
  default     = "8Gi"
}

variable "middlemanager_limits_cpu" {
  type        = string
  description = "amount of cpu limits for each middlemanager"
  default     = "512m"
}

variable "middlemanager_limits_memory" {
  type        = string
  description = "amount of memory limits for each middlemanager"
  default     = "8Gi"
}

variable "middlemanager_tolerations" {
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

// Overlord
variable "overlord_replicas" {
  type        = number
  description = "Number of replicas for the Overlord service"
  default     = 1
}

variable "overlord_requests_cpu" {
  type        = string
  description = "amount of cpu request for each overlord"
  default     = "512m"
}

variable "overlord_requests_memory" {
  type        = string
  description = "amount of memory request for each overlord"
  default     = "2Gi"
}

variable "overlord_limits_cpu" {
  type        = string
  description = "amount of cpu limits for each overlord"
  default     = "512m"
}

variable "overlord_limits_memory" {
  type        = string
  description = "amount of memory limits for each overlord"
  default     = "2Gi"
}

variable "overlord_tolerations" {
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

// Router
variable "router_replicas" {
  type        = number
  description = "Number of replicas for the Router service"
  default     = 1
}

variable "router_requests_cpu" {
  type        = string
  description = "amount of cpu request for each router"
  default     = "128m"
}

variable "router_requests_memory" {
  type        = string
  description = "amount of memory request for each router"
  default     = "512Mi"
}

variable "router_limits_cpu" {
  type        = string
  description = "amount of cpu limits for each router"
  default     = "128m"
}

variable "router_limits_memory" {
  type        = string
  description = "amount of memory limits for each router"
  default     = "512Mi"
}

variable "router_tolerations" {
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

// Druid Ingress objects
variable "enable_brokers_ingress" {
  description = "enable the ingress object for the brokers for external access"
  type        = bool
  default     = false
}

variable "brokers_annotations_ingress" {
  description = "list of annotations to add in the ingress object"
  type        = map(string)
  default     = {}
}

variable "brokers_host" {
  description = "host to use for accessing the brokers"
  type        = string
  default     = ""
}

variable "enable_router_ingress" {
  description = "enable the ingress object for the router for external access"
  type        = bool
  default     = false
}

variable "router_annotations_ingress" {
  description = "list of annotations to add in the ingress object"
  type        = map(string)
  default     = {}
}

variable "router_host" {
  description = "host to use for accessing the router"
  type        = string
  default     = ""
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

variable "broker_port" {
  type        = string
  description = "port exposed for the broker service"
  default     = "8082"
}

variable "overlord_port" {
  type        = string
  description = "port exposed for the overlord service"
  default     = "8090"
}
variable "middlemanager_port" {
  type        = string
  description = "port exposed for the middlemanager service"
  default     = "8084"
}
variable "historical_port" {
  type        = string
  description = "port exposed for the historical service"
  default     = "8083"
}
variable "coordinator_port" {
  type        = string
  description = "port exposed for the coordinator service"
  default     = "8081"
}
variable "router_port" {
  type        = string
  description = "port exposed for the router service"
  default     = "8888"
}
