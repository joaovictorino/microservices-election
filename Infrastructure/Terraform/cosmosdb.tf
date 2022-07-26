resource "azurerm_cosmosdb_account" "candidatesdb" {
  name                = "candidatesdb"
  location            = azurerm_resource_group.bootcamp.location
  resource_group_name = azurerm_resource_group.bootcamp.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = true

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location = azurerm_resource_group.bootcamp.location
    failover_priority = 0
    zone_redundant = false
  }
}

resource "azurerm_cosmosdb_mongo_database" "candidatesdb" {
  name                = "candidatesdb"
  resource_group_name = azurerm_resource_group.bootcamp.name
  account_name        = azurerm_cosmosdb_account.candidatesdb.name
  throughput          = 400
}