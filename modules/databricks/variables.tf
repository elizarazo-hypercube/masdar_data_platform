# Purpose: Define the variables for the Databricks module

# Basic Configuration Variables
variable "resource_prefix" {
  description = "The prefix to use for resource names"
  type        = string
}

variable "environment" {
  description = "The environment to use for resource names"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
}

variable "databricks_host_subnet_cidr" {
  description = "The CIDR block for the Databricks host subnet"
  type        = string
}

variable "databricks_container_subnet_cidr" {
  description = "The CIDR block for the Databricks container subnet"
  type        = string
}

# # Monitoring Configuration
# variable "log_analytics_workspace_id" {
#   description = "The ID of the Log Analytics workspace for monitoring"
#   type        = string
# }

variable "resource_group_name" {
  description = "The name of the resource group to use for the Databricks workspace"
  type        = string
}

variable "databricks_vnet_address_space" {
  description = "The address space for the Databricks virtual network"
  type        = string
}
