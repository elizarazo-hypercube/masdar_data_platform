# Creates Databricks workspace
resource "azurerm_databricks_workspace" "databricks" {
  name                = "${var.resource_prefix}-dataplatform-dbx-${var.environment}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.databricks_resource_group.name
  sku                 = "premium"
  tags                = var.tags

  custom_parameters {
    no_public_ip        = false
    virtual_network_id  = azurerm_virtual_network.main.id
    public_subnet_name  = azurerm_subnet.databricks_host_subnet.name
    private_subnet_name = azurerm_subnet.databricks_private.name
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.databricks_public_nsg_association.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.databricks_private_nsg_association.id
  }
}