terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.7.0"
    }
    # databricks = {
    #   source  = "databricks/databricks"
    #   version = "1.130.0"
    # }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  # Configuration options
  subscription_id = "8d814b03-5681-4dcc-8166-0d8b46e21998"
  features {}
}

# provider "databricks" {
#   host    = "https://adb-3949677546417593.13.azuredatabricks.net/"
#   profile = "masdar"
# }

module "databricks" {
  source = "../../modules/databricks"
  resource_prefix = var.resource_prefix
  environment = var.environment
  location = var.location
  tags = var.tags
  databricks_vnet_address_space = var.databricks_vnet_address_space
  databricks_host_subnet_cidr = var.databricks_host_subnet_cidr
  databricks_container_subnet_cidr = var.databricks_container_subnet_cidr
  resource_group_name = var.resource_group_name
  # log_analytics_workspace_id = var.log_analytics_workspace_id
}