resource "azurerm_mssql_server" "votessrv" {
  name                         = "votessrv"
  resource_group_name          = azurerm_resource_group.bootcamp.name
  location                     = azurerm_resource_group.bootcamp.location
  version                      = "12.0"
  administrator_login          = "bootcampuser"
  administrator_login_password = "Teste@admin123"
}

resource "azurerm_mssql_database" "votesdb" {
  name           = "votesdb"
  server_id      = azurerm_mssql_server.votessrv.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true
}