# Description: This file contains the output variables for the Databricks workspace module.

# Output the Databricks workspace URL
output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.databricks.workspace_url
}

# Output the private endpoint ID and private IP address
output "databricks_private_endpoint_id" {
  value = azurerm_private_endpoint.databricks_private_endpoint.id
}

output "databricks_private_endpoint_ip" {
  value = azurerm_private_endpoint.databricks_private_endpoint.private_service_connection[0].private_ip_address
}

# Output the private DNS zone name and DNS record IP address
output "databricks_dns_zone_name" {
  value = azurerm_private_dns_zone.databricks_private_dns_zone.name
}

output "databricks_dns_record_ip" {
  value = azurerm_private_dns_a_record.databricks_dns_record.records
}

# Output the managed resource group ID and workspace ID
output "workspace_managed_resource_group_id" {
  value = azurerm_databricks_workspace.databricks.managed_resource_group_id
}

output "workspace_id" {
  value = azurerm_databricks_workspace.databricks.workspace_id
}

# Output the managed resource group name
output "workspace_managed_resource_group_name" {
  value = split("/", azurerm_databricks_workspace.databricks.managed_resource_group_id)[4]
}

# Output the managed identity ID
output "managed_identity_id" {
  value = azurerm_databricks_workspace.databricks.workspace_id
}