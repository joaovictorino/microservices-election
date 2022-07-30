resource "azurerm_container_registry" "bootcampici" {
  name                     = "bootcampici"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  sku                      = "Basic"
  admin_enabled            = true

  depends_on = [
    var.resource_group
  ]
}