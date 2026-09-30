# Environment Configuration
environment = "prod"
resource_prefix = "masdar-hq"

# Resource Group Names
resource_group_name = "Masdar-DataPlatform"

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

# Secret Scope Names
secret_scope_names = ["masdar_hq"]