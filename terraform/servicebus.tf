# resource "azurerm_servicebus_namespace" "example" {
#   name                = "tfex-servicebus-namespace"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   sku                 = "Standard"

#   tags = {
#     source = "terraform"
#   }
# }

# resource "azurerm_servicebus_queue" "example" {
#   name         = "tfex_servicebus_queue"
#   namespace_id = azurerm_servicebus_namespace.example.id

#   enable_partitioning = true
# }