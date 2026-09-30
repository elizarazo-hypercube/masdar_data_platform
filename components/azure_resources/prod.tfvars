# Environment Configuration
environment = "prod"
location = "uaenorth"
resource_prefix = "masdar-hq"

# Resource Group Names
resource_group_name = "Masdar-DataPlatform"

# Databricks Configuration
databricks_vnet_address_space    = "10.201.4.0/22"
databricks_host_subnet_cidr      = "10.201.4.0/24"
databricks_container_subnet_cidr = "10.201.5.0/24"

# Log Analytics Configuration
# log_analytics_workspace_id = "/subscriptions/d9e6775f-e940-4ce8-a702-7d48d9ad07e3/resourceGroups/rg-management-uaenorth-01/providers/Microsoft.OperationalInsights/workspaces/log-management-uaenorth-01"

# Tags
tags = {
  Environment = "Production"
  ITOM_MONITORING = "Masdar"
  Application = "HQ DataPlatform"
  BusinessImpact = "High"
  CreatedBy = "Terraform"
  DR = "No"
  Owner = "IT"
  Uptime = "99.99"
}
