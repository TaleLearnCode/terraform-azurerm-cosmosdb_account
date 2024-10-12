# #############################################################################
# Terraform Module: Cosmos DB Account
# #############################################################################

module "resource_name" {
  source = "git::git@ssh.dev.azure.com:v3/JasperEnginesTransmissions/JETDEV/DVO_TerraformModules//src//azurerm//resource_name"

  resource_type  = local.resource_type
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix
  srv_comp_abbr  = var.srv_comp_abbr
  custom_name    = var.custom_name
  location       = var.location
  environment    = var.environment
}

resource "azurerm_cosmosdb_account" "target" {
  name                = module.resource_name.resource_name
  location            = var.location
  resource_group_name = var.resource_group_name
  
  offer_type           = var.offer_type
  kind                 = var.kind
  mongo_server_version = var.kind == "MongoDB" ? var.mongo_server_version : null
  free_tier_enabled    = var.free_tier_enabled

  automatic_failover_enabled = true

  dynamic "geo_location" {
    for_each = var.geo_locations != null ? var.geo_locations : local.default_failover_locations
    content {
      location = geo_location.value.location
      failover_priority = lookup(geo_location.value, "priority", 0)
      zone_redundant    = lookup(geo_location.value, "zone_redundant", false)
    }
  }

  consistency_policy {
    consistency_level = var.consistency_level
    max_interval_in_seconds = local.consistency_max_interval
    max_staleness_prefix    = local.max_staleness_prefix
  }

  dynamic "capabilities" {
    for_each = var.capabilities != null ? var.capabilities : []
    content {
      name = capabilities.value.name
    }
  }

  ip_range_filter = var.ip_range_filter

  public_network_access_enabled         = var.public_network_access_enabled
  is_virtual_network_filter_enabled     = var.is_virtual_network_filter_enabled
  network_acl_bypass_for_azure_services = var.network_acl_bypass_for_azure_services
  network_acl_bypass_ids                = var.network_acl_bypass_ids

  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rule != null ? toset(var.virtual_network_rule) : []
    content {
      id                                   = virtual_network_rule.value.id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint
    }
  }

  dynamic "backup" {
    for_each = var.backup != null ? ["enabled"] : []
    content {
      type                = lookup(var.backup, "type", null)
      interval_in_minutes = lookup(var.backup, "interval_in_minutes", null)
      retention_in_hours  = lookup(var.backup, "retention_in_hours", null)
      storage_redundancy  = lookup(var.backup, "storage_redundancy", null)
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? ["enabled"] : []
    content {
      type = var.identity_type
    }
  }

  tags = var.tags
  
}

resource "azurerm_key_vault_secret" "cosmosdb_account" {
  count        = var.create_connection_string_secret ? 1 : 0
  name         = var.connection_string_secret_name
  value        = azurerm_cosmosdb_account.target.primary_sql_connection_string
  key_vault_id = var.key_vault_id
}