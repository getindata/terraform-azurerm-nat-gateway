variable "resource_group_name" {
  description = "Azure resource group name where resources will be deployed"
  type        = string
}

variable "location" {
  description = "Location where resources will be deployed. If not provided it will be read from resource group location"
  type        = string
  default     = null
}

variable "descriptor_name" {
  description = "Name of the descriptor used to form a resource name"
  type        = string
  default     = "azure-nat-gateway"
}

variable "diagnostic_settings" {
  description = "Enables diagnostics settings for a resource and streams the logs and metrics to any provided sinks"
  type = object({
    enabled               = optional(bool, false)
    logs_destinations_ids = optional(list(string), [])
  })
  default  = {}
  nullable = false
}

variable "idle_timeout_in_minutes" {
  description = "The idle timeout which should be used in minutes"
  type        = number
  default     = 4
}

variable "zones" {
  description = "Specifies a list of Availability Zones in which this NAT Gateway should be located"
  type        = list(string)
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs which will be associated with NAT Gateway"
  type        = list(string)
  default     = []
}

variable "public_ip_prefix_ids" {
  description = "List of Public IP prefix IDs which will be associated with NAT Gateway"
  type        = list(string)
  default     = []
}

variable "public_ip_address_ids" {
  description = "List of Public IP IDs which will be associated with NAT Gateway"
  type        = list(string)
  default     = []
}

variable "public_ip" {
  description = "Public IPs that will be created for the NAT Gateway"
  type = object({
    count             = optional(number, 0)
    allocation_method = optional(string, "Static")
    zones             = optional(list(string))
    ip_version        = optional(string)
    sku               = optional(string, "Standard")
    sku_tier          = optional(string)
  })
  default  = {}
  nullable = false
}
