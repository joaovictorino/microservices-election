resource "azurerm_servicebus_namespace" "bootcamp" {
  name                = "electionbootcamp-namespace"
  location            = azurerm_resource_group.bootcamp.location
  resource_group_name = azurerm_resource_group.bootcamp.name
  sku                 = "Standard"

  tags = {
    source = "terraform"
  }
}

resource "azurerm_servicebus_queue" "votesmq" {
  name         = "votesmq"
  namespace_id = azurerm_servicebus_namespace.bootcamp.id

  enable_partitioning = true
}