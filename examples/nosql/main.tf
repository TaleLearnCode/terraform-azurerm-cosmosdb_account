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