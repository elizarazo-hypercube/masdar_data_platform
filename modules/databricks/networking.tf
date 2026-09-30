# Deploys a Databricks workspace using existing VNet and creates required subnets
# Configure values in terraform-prod.tfvars

# Creates a resource group for the Databricks workspace
data "azurerm_resource_group" "databricks_resource_group" {
  name = var.resource_group_name  
}

# Create Network Security Group for Databricks
resource "azurerm_network_security_group" "databricks_nsg" {
  name                = "${var.resource_prefix}-databricks-hq-nsg-${var.environment}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.databricks_resource_group.name

  security_rule {
    name                       = "allow-inbound-databricks"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "databricks-worker-to-databricks-webapp"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["443", "3306", "8443-8451"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureDatabricks"
  }

  security_rule {
    name                       = "databricks-worker-to-sql"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Sql"
  }

  security_rule {
    name                       = "databricks-worker-to-storage"
    priority                   = 103
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Storage"
  }

  security_rule {
    name                       = "databricks-worker-to-eventhub"
    priority                   = 104
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9093"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "EventHub"
  }

  security_rule {
    name                       = "databricks-control-plane-to-worker-ssh"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "AzureDatabricks"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "databricks-control-plane-to-worker-proxy"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5557"
    source_address_prefix      = "AzureDatabricks"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = var.tags
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.resource_prefix}-vnet-${var.environment}-${var.location}-01"
  location            = data.azurerm_resource_group.databricks_resource_group.location
  resource_group_name = data.azurerm_resource_group.databricks_resource_group.name

  address_space = [var.databricks_vnet_address_space]

  tags = var.tags
}

resource "azurerm_subnet" "databricks_host_subnet" {
  name                 = "${var.resource_prefix}-snet-databricks-public-${var.environment}-${var.location}-01"
  resource_group_name  = data.azurerm_resource_group.databricks_resource_group.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.databricks_host_subnet_cidr] 

  service_endpoint {
    service = "Microsoft.Storage"
  }
  service_endpoint {
    service = "Microsoft.KeyVault"
  }

  delegation {
    name = "databricks-del"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Create private subnet for Databricks
resource "azurerm_subnet" "databricks_private" {
  name                 = "${var.resource_prefix}-snet-databricks-private-${var.environment}-${var.location}-01"
  resource_group_name  = data.azurerm_resource_group.databricks_resource_group.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.databricks_container_subnet_cidr] 

  service_endpoint  {
    service="Microsoft.Storage"
  }

  service_endpoint {
    service="Microsoft.KeyVault"
  }

  delegation {
    name = "databricks-del"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Associate NSG with public subnet
resource "azurerm_subnet_network_security_group_association" "databricks_public_nsg_association" {
  subnet_id                 = azurerm_subnet.databricks_host_subnet.id
  network_security_group_id = azurerm_network_security_group.databricks_nsg.id
}

# Associate NSG with private subnet
resource "azurerm_subnet_network_security_group_association" "databricks_private_nsg_association" {
  subnet_id                 = azurerm_subnet.databricks_private.id
  network_security_group_id = azurerm_network_security_group.databricks_nsg.id
}

# resource "azurerm_log_analytics_workspace" "databricks_log_analytics_workspace" {
#   name                = "${var.resource_prefix}-log-analytics-workspace-${var.environment}"
#   location            = var.location
#   resource_group_name = data.azurerm_resource_group.databricks_resource_group.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
#   tags                = var.tags
# }

# # Configure diagnostic settings for the Databricks workspace
# resource "azurerm_monitor_diagnostic_setting" "databricks_diagnostics" {
#   name                       = "${var.resource_prefix}-databricks-diagnostics-${var.environment}"
#   target_resource_id         = azurerm_databricks_workspace.databricks.id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.databricks_log_analytics_workspace.id

#   enabled_log {
#     category = "dbfs"
#   }

#   enabled_log {
#     category = "clusters"
#   }

#   enabled_log {
#     category = "accounts"
#   }

#   enabled_log {
#     category = "jobs"
#   }

#   enabled_log {
#     category = "notebook"
#   }

#   enabled_log {
#     category = "ssh"
#   }

#   enabled_log {
#     category = "workspace"
#   }

#   enabled_log {
#     category = "secrets"
#   }

#   enabled_log {
#     category = "sqlPermissions"
#   }

#   enabled_log {
#     category = "instancePools"
#   }
# }

# # Note: Diagnostic settings are managed by an Azure policy and should not be modified here.