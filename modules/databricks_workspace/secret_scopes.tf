

# data "azurerm_client_config" "current" {}

# # The first-party "AzureDatabricks" enterprise application
# # (well-known application ID, same in every tenant)
# data "azuread_service_principal" "azure_databricks" {
#   client_id = "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d"
# }

data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "databricks_secret_scope" {
  name                = replace("${var.resource_prefix}-db-kv-${var.environment}", "-", "") 
  resource_group_name = var.resource_group_name
}

resource "databricks_secret_scope" "kv" {
  for_each = toset(var.secret_scope_names)
  name = each.value

  keyvault_metadata {
    resource_id = data.azurerm_key_vault.databricks_secret_scope.id
    dns_name    = data.azurerm_key_vault.databricks_secret_scope.vault_uri
  }
}

resource "databricks_secret_acl" "all_users_read" {
  for_each = toset(var.secret_scope_names)
  scope      = databricks_secret_scope.kv[each.value].name
  principal  = "users"
  permission = "READ"
}

# # Lets the deploying identity manage secrets in the vault
# resource "azurerm_key_vault_access_policy" "deployer" {
#   key_vault_id = azurerm_key_vault.databricks_secret_scope.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azurerm_client_config.current.object_id

#   secret_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
# }

# # Lets Databricks read secrets
# resource "azurerm_key_vault_access_policy" "databricks" {
#   key_vault_id = azurerm_key_vault.this.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azuread_service_principal.azure_databricks.object_id

#   secret_permissions = ["Get", "List"]
# }

# # The Databricks secret scope backed by the vault
# resource "databricks_secret_scope" "kv" {
#   name = var.resource_prefix

#   keyvault_metadata {
#     resource_id = azurerm_key_vault.this.id
#     dns_name    = azurerm_key_vault.this.vault_uri
#   }

#   depends_on = [azurerm_key_vault_access_policy.databricks]
# }