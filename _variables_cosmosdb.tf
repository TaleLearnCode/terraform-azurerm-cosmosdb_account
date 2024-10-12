# #############################################################################
# Variables: Cosmos DB Account
# #############################################################################

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which the Cosmos DB account should be created."
}

variable "offer_type" {
  type        = string
  default     = "Standard"
  description = "The Offer Type to use for this Cosmos DB account. Possible values are Standard and Autoscale."
}

variable "kind" {
  type        = string
  default     = "GlobalDocumentDB"
  description = "The kind of Cosmos DB account to create. Possible values are GlobalDocumentDB, MongoDB, and Parse"
}

variable "account_type" {
  type        = string
  default     = "NoSQL"
  description = "The type of Cosmos DB account to create. Possible values are Cassandra, Gremlin, Mongo, NoSQL, PostgreSQL, and Table."
}

locals {
  resource_type = {
    NoSQL      = "cosmosdb_account_nosql"
    Table      = "cosmosdb_account_table"
    Cassandra  = "cosmosdb_account_cassandra"
    Gremlin    = "cosmosdb_account_gremlin"
    Mongo      = "cosmosdb_account_mongo"
    PostgreSQL = "cosmosdb_account_postgresql"
  }[var.account_type]
}

variable "mongo_server_version" {
  type        = string
  default     = null
  description = "The version of MongoDB to use for this Cosmos DB account. Possible values are 3.2, 3.6, 4.0, and 4.2."
}

variable "free_tier_enabled" {
  type        = bool
  default     = false
  description = "Whether or not to enable the free tier for this Cosmos DB account."
}

variable "geo_locations" {
  type        = map(map(string))
  default     = null
  description = "The name of the Azure regions to host replicated data and their priority."
}

variable "zone_redundancy_enabled" {
  type        = bool
  default     = false
  description = "Whether or not to enable zone redundancy for this Cosmos DB account."
}

locals {
  default_failover_locations = {
    default = {
      location       = var.location
      zone_redundant = var.zone_redundancy_enabled
    }
  }
}

variable "consistency_level" {
  type        = string
  default     = "Session"
  description = "The Consistency Level to use for this Cosmos DB account. Possible values are Strong, BoundedStaleness, Session, ConsistentPrefix, and Eventual."
}

variable "consistency_max_interval" {
  type        = number
  default     = 5
  description = "When used with the Bounded Staleness consistency level, this value represents the maximum interval in seconds that the data read by this Cosmos DB account is allowed to be behind the latest write. The accepted range for this value is `1` to `86400`. Defaults to `5`. Required when `consistency_level` is set to `BoundedStalness`."
  validation {
    condition     = var.consistency_max_interval >= 1 && var.consistency_max_interval <= 86400
    error_message = "The consistency_max_interval must be between 1 and 86400."
  }
}

locals {
  consistency_max_interval = var.consistency_level == "BoundedStaleness" ? var.consistency_max_interval : null
}


variable "max_staleness_prefix" {
  type        = number
  default     = 100
  description = "When used with the Bounded Staleness consistency level, this value represents the maximum staleness in terms difference in sequence numbers (aka version) in the read results. The accepted range for this value is `10` to `2147483647`. Defaults to `100`. Required when `consistency_level` is set to `BoundedStalness`."
  validation {
    condition     = var.max_staleness_prefix >= 10 && var.max_staleness_prefix <= 2147483647
    error_message = "The max_staleness_prefix must be between 10 and 2147483647."
  }
}

locals {
  max_staleness_prefix = var.consistency_level == "BoundedStaleness" ? var.max_staleness_prefix : null
}

#variable "capabilities" {
#  type        = list(map(string))
#  default     = []
#  description = "A list of Cosmos DB capabilities to enable for this account. Possible values are AllowSelfServeUpgradeToMongo36, DisableRateLimitingResponses, EnableAggregationPipeline, EnableCassandra, EnableGremlin, EnableMongo, EnableMongo16MBDocumentSupport, EnableMongoRetryableWrites, EnableMongoRoleBasedAccessControl, EnableNoSQLVectorSearch, EnablePartialUniqueIndex, EnableServerless, EnableTable, EnableTtlOnCustomPath, EnableUniqueCompoundNestedDocs, MongoDBv3.4 and mongoEnableDocLevelTTL."
#}

variable "capabilities" {
  type        = list(string)
  default     = []
  description = "A list of Cosmos DB capabilities to enable for this account. Possible values are AllowSelfServeUpgradeToMongo36, DisableRateLimitingResponses, EnableAggregationPipeline, EnableCassandra, EnableGremlin, EnableMongo, EnableMongo16MBDocumentSupport, EnableMongoRetryableWrites, EnableMongoRoleBasedAccessControl, EnableNoSQLVectorSearch, EnablePartialUniqueIndex, EnableServerless, EnableTable, EnableTtlOnCustomPath, EnableUniqueCompoundNestedDocs, MongoDBv3.4 and mongoEnableDocLevelTTL."
}

variable "ip_range_filter" {
  type        = list(string)
  default     = []
  description = "The set of IP addresses or IP address ranges in CIDR form to allow through the firewall for this Cosmos DB account."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether or not public network access is allowed for this Cosmos DB account."
}

variable "is_virtual_network_filter_enabled" {
  type        = bool
  default     = false
  description = "Whether or not to enable virtual network filtering for this Cosmos DB account."
}

variable "network_acl_bypass_for_azure_services" {
  type        = bool
  default     = false
  description = "Whether or not to allow Azure services to bypass the network ACL for this Cosmos DB account."
}

variable "network_acl_bypass_ids" {
  type        = list(string)
  default     = []
  description = "The list of resource IDs of the virtual network subnet to allow network access from for this Cosmos DB account."
}

variable "virtual_network_rule" {
  type        = list(object({
    id                                   = string,
    ignore_missing_vnet_service_endpoint = bool
  }))
  default     = null
  description = "Configures the virtual network subnets allowed to access this Cosmos DB account."
}

variable "backup" {
  description = "Backup block with type (Continuous / Periodic), interval_in_minutes, retention_in_hours keys and storage_redundancy"
  type = object({
    type                = string
    interval_in_minutes = number
    retention_in_hours  = number
    storage_redundancy  = string
  })
  default = {
    type                = "Periodic"
    interval_in_minutes = 3 * 60
    retention_in_hours  = 7 * 24
    storage_redundancy  = "Geo"
  }
}

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "The Identity Type to use for this Cosmos DB account. Possible values are `SystemAssigned`, `UserAssigned`, and `SystemAssigned, UserAssigned`."
}

variable "create_connection_string_secret" {
  type        = bool
  description = "Should a connection string secret be created in the Azure Key Vault? Defaults to false."
  default     = false
}

variable "connection_string_secret_name" {
  type        = string
  description = "The name of the secret to create in the Azure Key Vault."
  default     = "null"
}

variable "key_vault_id" {
  type        = string
  description = "The ID of the Azure Key Vault in which to create the secret. This is required if 'create_connection_string_secret' is set to true."
  default     = "null"
}