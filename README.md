# Azure Cosmos DB Account Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md)

This module manages Azure Cosmos DB accounts using the [azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest) Terraform provider.

## Providers

| Name    | Version |
| ------- | ------- |
| azurerm | ~> 4.1. |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| Regions | TaleLearnCode/regions/azurerm | ~> .0.0.1-pre |

## Resources

No resources.

## Usage

```hcl
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

For more detailed instructions on using this module: please refer to the appropriate example:

- [NoSQL](examples/nosql/README.md)

## Inputs

| Name                                  | Description                                                  | Type              | Default            | Required |
| ------------------------------------- | ------------------------------------------------------------ | ----------------- | ------------------ | -------- |
| account_type                          | The type of Cosmos DB account to create. Possible values are `Cassandra`, `Gremlin`, `Mongo`, `NoSQL`, `PostgreSQL`, and `Table`. | string            | `NoSQL`            | no       |
| backup                                | Backup block with type (Continuous / Periodic), interval_in_minutes, retention_in_hours keys and storage_redundancy. | object            | See below          | no        |
| capabilities                          | A list of Cosmos DB capabilities to enable for this account. Possible values are `AllowSelfServeUpgradeToMongo36`, `DisableRateLimitingResponses`, `EnableAggregationPipeline`, `EnableCassandra`, `EnableGremlin`, `EnableMongo`, `EnableMongo16MBDocumentSupport`, `EnableMongoRetryableWrites`, `EnableMongoRoleBasedAccessControl`, `EnableNoSQLVectorSearch`, `EnablePartialUniqueIndex`, `EnableServerless`, `EnableTable`, `EnableTtlOnCustomPath`, `EnableUniqueCompoundNestedDocs`, `MongoDBv3.4` and `mongoEnableDocLevelTTL`. | list(map(string)) | []                 | no       |
| connection_string_secret_name         | The name of the secret to create in the Azure Key Vault.     | string            | null               | no       |
| consistency_level                     | The Consistency Level to use for this Cosmos DB account. Possible values are `Strong`, `BoundedStaleness`, `Session`, `ConsistentPrefix`, and `Eventual`. | string            | `Session`          | no       |
| consistency_max_interval              | The consistency_max_interval must be between `1` and `86400`. | number            | 5                  | no       |
| create_connection_string_secret       | Should a connection string secret be created in the Azure Key Vault? | bool              | false              | no       |
| custom_name                           | If set, the custom name to use instead of the generated name. | string            | NULL               | no       |
| environment                           | The environment where the resources are deployed to. Valid values are `dev`, `qa`, `e2e`, and `prod`. | string            | N/A                | yes      |
| free_tier_enabled                     | Whether or not to enable the free tier for this Cosmos DB account. | bool              | false              | no       |
| geo_locations                         | The name of the Azure regions to host replicated data and their priority. | map(map(string))  | null               | no       |
| identity_type                         | The type of Managed Service Identity to assign to the Service Bus namespace. Options are `SystemAssigned`, `UserAssigned`, and `SystemAssigned, UserAssigned` (to enable both). | string            | `SystemAssigned`   | no       |
| ip_range_filter                       | The set of IP addresses or IP address ranges in CIDR form to allow through the firewall for this Cosmos DB account. | list(string)      | []                 | no       |
| is_virtual_network_filter_enabled     | Whether or not to enable virtual network filtering for this Cosmos DB account. | bool              | false              | no       |
| key_vault_id                          | The identifier of the Azure Key Vault in which to create the secret. This is required if `create_connection_string_secret` is set to true. | string            | null               | no       |
| kind                                  | The kind of Cosmos DB account to create. Possible values are `GlobalDocumentDB`, `MongoDB`, and `Parse`. | string            | `GlobalDocumentDB` | no       |
| location                              | The Azure Region in which all resources will be created      | string            | N/A                | yes      |
| max_staleness_prefix                  | The max_staleness_prefix must be between 10 and 2147483647.  | number            | 100                | no       |
| mongo_server_version                  | The version of MongoDB to use for this Cosmos DB account. Possible values are `3.2`, `3.6`, `4.0`, and `4.2`. | string            | null               | no       |
| name_prefix                           | Optional prefix to apply to the generated name.              | string            | ""                 | no       |
| name_suffix                           | Optional suffix to apply to the generated name.              | string            | ""                 | no       |
| network_acl_bypass_for_azure_services | Whether or not to allow Azure services to bypass the network ACL for this Cosmos DB account. | bool              | false              | no       |
| network_acl_bypass_ids                | The list of resource IDs of the virtual network subnet to allow network access from for this Cosmos DB account. | list(string)      | []                 | no       |
| offer_type                            | The Offer Type to use for this Cosmos DB account. Possible values are `Standard` and `Autoscale`. | string            | `Standard`         | no       |
| public_network_access_enabled         | Whether or not public network access is allowed for this Cosmos DB account. | bool              | true               | no       |
| resource_group_name                   | The name of the Resource Group in which the Service Bus namespace should be created. | string            | N/A                | yes      |
| service_principal_object_id           | The object identifier of the service principal.              | string            | N/A                | yes      |
| srv_comp_abbr                         | The abbreviation of the service or component for which the resources are being created for. | string            | NULL               | no       |
| tags                                  | A map of tags to apply to all resources.                     | map               | N/A                | no       |
| virtual_network_rule                  | Configures the virtual network subnets allowed to access this Cosmos DB account. | list(object)      | null               | no       |
| zone_redundancy_enabled               | Whether or not to enable zone redundancy for this Cosmos DB account. | bool              | false              | no       |

Default `backup` value

```
default = {
  type                = "Periodic"
  interval_in_minutes = 3 * 60
  retention_in_hours  = 7 * 24
  storage_redundancy  = "Geo"
}
```

## Outputs

| Name                          | Description                                                  |
| ----------------------------- | ------------------------------------------------------------ |
| cosmosdb_account              | The managed Azure Cosmos DB account.                         |
| connection_string_secret_name | The name of the secret in the Key Vault that contains the connection string. |

## Naming Guidelines

| Guideline                       |                                                              |
| ------------------------------- | ------------------------------------------------------------ |
| Resource Type Identifier        | Depends on `account_type`. See table below                   |
| Scope                           | Global                                                       |
| Max Overall Length              | 3 - 43 characters                                            |
| Allowed Component Name Length * | 30 characters                                                |
| Valid Characters                | Alphanumerics and hyphens. Start with letter. End with alphanumeric. |
| Regex                           | `^(?!.*--)(?!.*..)(?!.*.$)(?!.*-$)([a-z0-9]{3,44})$"`        |

* Allowed Component Name Length is a combination of the `srv_comp_abbr`, `name_prefix`, and `name_suffix` or the `custom_name` if used.

**Resource Type Indicators**

| account_type | Resource Type Identifier |
| ------------ | ------------------------ |
| Cassandra    | cascas                   |
| Gremlin      | cosgrm                   |
| Mongo        | cosmon                   |
| NoSQL        | cosno                    |
| PostgreSQL   | cospos                   |
| Table        | costab                   |