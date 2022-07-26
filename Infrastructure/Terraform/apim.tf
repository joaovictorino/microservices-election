resource "azurerm_api_management" "election-apim" {
  name                = "election-apim"
  location            = azurerm_resource_group.bootcamp.location
  resource_group_name = azurerm_resource_group.bootcamp.name
  publisher_name      = "bootcamp"
  publisher_email     = "jhvictorino@gmail.com"

  sku_name = "Developer_1"
}