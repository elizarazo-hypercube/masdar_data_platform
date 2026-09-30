variable "resource_prefix" {
  type        = string
  description = "The prefix for the resource"
}

variable "environment" {
  type        = string
  description = "The environment"
}

variable "resource_group_name" { 
  type        = string
  description = "The name of the resource group"
}

variable "tags" {
  type        = map(string)
  description = "The tags for the resource"
}

variable "secret_scope_names" {
  type        = list(string)
  description = "The names of the secret scopes"
}