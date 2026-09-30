#follows https://learn.microsoft.com/en-in/azure/databricks/security/network/classic/vnet-inject#egress-ip

# Stable public IP for Databricks outbound traffic
resource "azurerm_public_ip" "databricks_egress" {
  name                = "${var.resource_prefix}-pip-db-egress-${var.environment}-${var.location}-hq-01"
  location            = data.azurerm_resource_group.databricks_resource_group.location
  resource_group_name = data.azurerm_resource_group.databricks_resource_group.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = var.tags
}

resource "azurerm_nat_gateway" "databricks" {
  name                = "${var.resource_prefix}-nat-db-${var.environment}-${var.location}-hq-01"
  location            = data.azurerm_resource_group.databricks_resource_group.location
  resource_group_name = data.azurerm_resource_group.databricks_resource_group.name

  sku_name            = "Standard"
  idle_timeout_in_minutes = 10

  tags = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "databricks" {
  nat_gateway_id       = azurerm_nat_gateway.databricks.id
  public_ip_address_id = azurerm_public_ip.databricks_egress.id
}

resource "azurerm_subnet_nat_gateway_association" "databricks_public" {
  subnet_id      = azurerm_subnet.databricks_host_subnet.id
  nat_gateway_id = azurerm_nat_gateway.databricks.id
}

resource "azurerm_subnet_nat_gateway_association" "databricks_private" {
  subnet_id      = azurerm_subnet.databricks_private.id
  nat_gateway_id = azurerm_nat_gateway.databricks.id
}