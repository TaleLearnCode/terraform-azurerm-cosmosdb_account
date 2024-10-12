# #############################################################################
# Outputs
# #############################################################################

output "cosmosdb_account" {
  value       = azurerm_cosmosdb_account.target
  description = "The managed Cosmos DB account."
}

output "connection_string_secret_name" {
  value       = var.connection_string_secret_name == "null" ? null : var.connection_string_secret_name
  description = "The name of the secret in the Key Vault that contains the connection string."
}