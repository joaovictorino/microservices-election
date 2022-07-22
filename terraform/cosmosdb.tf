# resource "azurerm_cosmosdb_account" "db" {
#   name                = "tfex-cosmos-db-${random_integer.ri.result}"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   offer_type          = "Standard"
#   kind                = "MongoDB"

#   enable_automatic_failover = true

#   capabilities {
#     name = "EnableAggregationPipeline"
#   }

#   capabilities {
#     name = "mongoEnableDocLevelTTL"
#   }

#   capabilities {
#     name = "MongoDBv3.4"
#   }

#   capabilities {
#     name = "EnableMongo"
#   }

#   consistency_policy {
#     consistency_level       = "BoundedStaleness"
#     max_interval_in_seconds = 300
#     max_staleness_prefix    = 100000
#   }

#   geo_location {
#     location          = "eastus"
#     failover_priority = 1
#   }

#   geo_location {
#     location          = "eastus"
#     failover_priority = 0
#   }
# }

# resource "azurerm_cosmosdb_mongo_database" "example" {
#   name                = "tfex-cosmos-mongo-db"
#   resource_group_name = data.azurerm_cosmosdb_account.example.resource_group_name
#   account_name        = data.azurerm_cosmosdb_account.example.name
#   throughput          = 400
# }