resource "azurerm_api_management" "election-apim" {
  name                = "election-apim"
  location            = azurerm_resource_group.bootcamp.location
  resource_group_name = azurerm_resource_group.bootcamp.name
  publisher_name      = "bootcamp"
  publisher_email     = "jhvictorino@gmail.com"

  sku_name = "Developer_1"
}

resource "azurerm_aadb2c_directory" "bootcamp-ici" {
  country_code            = "US"
  data_residency_location = "United States"
  display_name            = "bootcamp-ici"
  domain_name             = "bootcampici.onmicrosoft.com"
  resource_group_name     = azurerm_resource_group.bootcamp.name
  sku_name                = "PremiumP1"
}

provider "azuread" {
  tenant_id = azurerm_aadb2c_directory.bootcamp-ici.tenant_id
}

resource "azuread_application" "election-app-ad" {
  display_name = "election-api"
}

resource "azuread_application_password" "election-app-ad-pwd" {
  application_object_id = azuread_application.election-app-ad.object_id
  end_date_relative     = "36h"
}

resource "azurerm_api_management_identity_provider_aadb2c" "election-apim-aadb2c" {
  resource_group_name = azurerm_resource_group.bootcamp.name
  api_management_name = azurerm_api_management.election-apim.name
  client_id           = azuread_application.election-app-ad.application_id
  client_secret       = "P@55w0rD!"
  allowed_tenant      = "bootcampici.onmicrosoft.com"
  signin_tenant       = "bootcampici.onmicrosoft.com"
  authority           = "bootcampici.b2clogin.com"
  signin_policy       = "B2C_1_Login"
  signup_policy       = "B2C_1_Signup"

  depends_on = [
    azuread_application_password.election-app-ad-pwd,
    azurerm_api_management.election-apim,
    azuread_application.election-app-ad
  ]
}