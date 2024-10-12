# Example: Cosmos DB Account for NoSQL API

This module manages a Cosmos DB account using the [azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest) Terraform provider.  This example shows how to use the module to manage a Cosmos DB account for the **NoSQL** API.

## Example Usage

```hcl
variable "environment" {
  type        = string
  default     = "DEV"
  description = "The environment for the resource."
}

data "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "North Central US"
}

data "azurerm_key_vault" "example" {
  name                = "mykeyvault"
  resource_group_name = "some-resource-group"
}

module "example" {
  source    = "TaleLearnCode/cosmosdb_account/azurerm"
  version   = "0.0.1-pre"
  providers = {
    azurerm = azurerm
  }

  srv_comp_abbr       = "EXP"
  location            = data.azurerm_resource_group.example.location
  environment         = var.environment
  resource_group_name = data.azurerm_resouce_group.example.name

  create_connection_string_secret = true
  key_vault_id                    = data.azurerm_key_vault.example.id
  connection_string_secret_name   = "CosmosDBConnectionString"
  
}
```

You are specifying three values:

- **srv_comp_abbr**: The abbreviation for the service/component the Cosmos DB account supports.
- **location**: The Azure Region in which all resources will be created.
- **environment**: The environment where the resources are deployed to.
- **resource_group_name**: The name of the Resource Group in which the Cosmos DB account will be created.
- **create_connection_string_secret**: Indication whether a connection string secret should be created in Azure Key Vault.
- **key_vault_id**: Identifier of the Azure Key Vault in which to create the secret.
- **connection_string_secret_name**: The name of the secret to create in the Azure Key Vault store.

This will result in an Azure Service Bus namespace named: `cosno-exp-dev-usnc`.