terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.7.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.135.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  # Configuration options
  subscription_id = "8d814b03-5681-4dcc-8166-0d8b46e21998"
  features {}
}

provider "databricks" {
  host    = "https://adb-7405610029610686.6.azuredatabricks.net/"
  profile = "masdar_hq"
}

module "databricks_workspace" {
  source = "../../modules/databricks_workspace"
  resource_prefix = var.resource_prefix
  environment = var.environment
  tags = var.tags
  resource_group_name = var.resource_group_name
  secret_scope_names = var.secret_scope_names
  # log_analytics_workspace_id = var.log_analytics_workspace_id
}