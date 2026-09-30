

# data "azurerm_client_config" "current" {}

# # The first-party "AzureDatabricks" enterprise application
# # (well-known application ID, same in every tenant)
# data "azuread_service_principal" "azure_databricks" {
#   client_id = "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d"
# }

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "databricks_secret_scope" {
  name                = replace("${var.resource_prefix}-db-kv-${var.environment}", "-", "")   # globally unique, 3-24 chars
  location            = data.azurerm_resource_group.databricks_resource_group.location
  resource_group_name = data.azurerm_resource_group.databricks_resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  # Access policy model (the most broadly compatible with Databricks scopes)
  rbac_authorization_enabled = false

  soft_delete_retention_days = 90
  purge_protection_enabled   = true

  public_network_access_enabled = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"   # "Allow trusted Microsoft services"
    ip_rules       = []                # add your CI/runner IPs if needed
  }
  tags = var.tags
}

# Lets the deploying identity manage secrets in the vault
resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = azurerm_key_vault.databricks_secret_scope.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
}

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