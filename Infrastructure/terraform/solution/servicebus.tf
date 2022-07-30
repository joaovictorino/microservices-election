resource "azurerm_servicebus_namespace" "bootcamp" {
  name                = "electionbootcamp-namespace"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
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