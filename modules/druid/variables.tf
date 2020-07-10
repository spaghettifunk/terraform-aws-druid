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

variable "broker_replicas" {
  type        = number
  description = "Number of replicas for the Broker service"
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
}

variable "coordinator_replicas" {
  type        = number
  description = "Number of replicas for the Coordinator service"
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
}

variable "historical_replicas" {
  type        = number
  description = "Number of replicas for the Historical service"
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
}

variable "middlemanager_replicas" {
  type        = number
  description = "Number of replicas for the Middlemanager service"
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
}

variable "overlord_replicas" {
  type        = number
  description = "Number of replicas for the Overlord service"
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
}

variable "router_replicas" {
  type        = number
  description = "Number of replicas for the Router service"
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
