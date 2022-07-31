output "azurerm_container_registry" {
  value = azurerm_container_registry.bootcampici
}

output "azurerm_cosmosdb_account" {
  value = azurerm_cosmosdb_account.candidatesdb
}

output "azurerm_mssql_server" {
  value = azurerm_mssql_server.votessrv
}

output "azurerm_mssql_database" {
  value = azurerm_mssql_database.votesdb
}

output "azurerm_servicebus_namespace" {
  value = azurerm_servicebus_namespace.bootcamp
}