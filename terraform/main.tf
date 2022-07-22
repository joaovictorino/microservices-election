terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

resource "azurerm_resource_group" "bootcamp" {
  name     = "bootcamp"
  location = "eastus"
}

resource "azurerm_container_registry" "acr" {
  name                     = "bootcampici"
  resource_group_name      = azurerm_resource_group.bootcamp.name
  location                 = azurerm_resource_group.bootcamp.location
  sku                      = "Basic"
  admin_enabled            = true

  depends_on = [
    azurerm_resource_group.bootcamp
  ]
}

resource "azurerm_container_group" "election" {
  name                = "election"
  location            = azurerm_resource_group.bootcamp.location
  resource_group_name = azurerm_resource_group.bootcamp.name
  ip_address_type     = "Public"
  dns_name_label      = "election"
  os_type             = "Linux"

  image_registry_credential {
    server = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  container {
    name   = "springapp"
    image  = "auladockeracr.azurecr.io/springapp:latest"
    cpu    = "0.5"
    memory = "1.5"
    
    ports {
      port     = 8080
      protocol = "TCP"
    }

    environment_variables = {
      "MYSQL_URL" = "jdbc:mysql://tflab-mysqlserver-1-teste.mysql.database.azure.com:3306/exampledb?useSSL=true&requireSSL=false"
      "MYSQL_USER" = "mysqladminun@tflab-mysqlserver-1-teste.mysql.database.azure.com"
      "MYSQL_PASS" = "easytologin4once!"
    }

  }

  depends_on = [
    azurerm_container_registry.acr
  ]
}