variable "namespace" {
  type        = string
  description = "Druid namespace where to be deployed"
  default     = "druid"
}

// Druid variables
variable "druid_image" {
  type        = string
  description = "Docker registry used to fetch the Apache Druid image"
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

coordinator_limits = object({
  memory = var.coordinator_limits_memory
  cpu    = var.coordinator_limits_cpu
})

coordinator_requests = object({
  memory = var.coordinator_requests_memory
  cpu    = var.coordinator_requests_cpu
})

variable "router_limits" {
  type        = object({
    cpu = string
    memory = string
  })
  description = "amount of cpu limits for each router"
  default     = "128m"
}

variable "router_requests" {
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

// ingress
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
