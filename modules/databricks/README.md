# Databricks Workspace Deployment with Diagnostic Settings

This Terraform configuration deploys an Azure Databricks workspace with custom virtual network and subnets, and configures diagnostic settings to send logs and metrics to an Azure Log Analytics workspace.

## Prerequisites

- Terraform installed on your local machine.
- Azure CLI installed and authenticated.
- An existing Azure Resource Group.
- An existing Log Analytics workspace.

## Files

- `main.tf`: Contains the main Terraform configuration for deploying the Databricks workspace.
- `variables.tf`: Defines the input variables for the Terraform configuration.
- `outputs.tf`: Defines the output values for the Terraform configuration.
- `terraform.tfvars`: Provides the values for the input variables.

## Variables

The following variables need to be defined in the `variables.tf` file or provided via `terraform.tfvars`:

- `resource_prefix`: Prefix for naming resources.
- `location`: Azure region where resources will be deployed.
- `databricks_workspace_sku`: SKU for the Databricks workspace.
- `tags`: Tags to apply to the resources.
- `databricks_vnet_id`: ID of the custom virtual network.
- `databricks_public_subnet`: Name of the public subnet.
- `databricks_private_subnet`: Name of the private subnet.
- `log_analytics_workspace_id`: ID of the Log Analytics workspace.

## Usage

1. Clone the repository and navigate to the directory containing the Terraform configuration files.

2. Initialize Terraform:

    ```sh
    terraform init
    ```

3. Review the Terraform plan:

    ```sh
    terraform plan
    ```

4. Apply the Terraform configuration:

    ```sh
    terraform apply
    ```

5. Confirm the apply action by typing `yes`.

## Outputs

The following outputs will be provided after the deployment:

- `databricks_workspace_id`: The ID of the deployed Databricks workspace.
- `databricks_workspace_url`: The URL of the deployed Databricks workspace.

## Cleanup

To destroy the resources created by this Terraform configuration, run:

```sh
terraform destroy
```

## Diagnostic Settings

Diagnostic settings for Databricks are managed by an Azure policy. Do not attempt to modify these settings through Terraform, as they are controlled by the policy.

## Additional Notes

- Ensure all tags are set in the `terraform-prod.tfvars` file to avoid being prompted for values during execution.
- Review the Network Security Group (NSG) rules to ensure they comply with any Network Intent Policies.
</rewritten_file>