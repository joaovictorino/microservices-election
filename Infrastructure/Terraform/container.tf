resource "azurerm_container_group" "election" {
  name                = "election"
  location            = azurerm_resource_group.bootcamp.location
  resource_group_name = azurerm_resource_group.bootcamp.name
  ip_address_type     = "Public"
  dns_name_label      = "election"
  os_type             = "Linux"

  image_registry_credential {
    server = azurerm_container_registry.bootcampici.login_server
    username = azurerm_container_registry.bootcampici.admin_username
    password = azurerm_container_registry.bootcampici.admin_password
  }

  container {
    name   = "candidatesapi"
    image  = "bootcampici.azurecr.io/candidatesapi:latest"
    cpu    = "0.5"
    memory = "1.5"
    
    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      "MYSQL_URL" = "jdbc:mysql://tflab-mysqlserver-1-teste.mysql.database.azure.com:3306/exampledb?useSSL=true&requireSSL=false"
      "MYSQL_USER" = "mysqladminun@tflab-mysqlserver-1-teste.mysql.database.azure.com"
      "MYSQL_PASS" = "easytologin4once!"
    }
  }

  container {
    name   = "votesapi"
    image  = "bootcampici.azurecr.io/votesapi:latest"
    cpu    = "0.5"
    memory = "1.5"
    
    ports {
      port     = 81
      protocol = "TCP"
    }

    environment_variables = {
      "MYSQL_URL" = "jdbc:mysql://tflab-mysqlserver-1-teste.mysql.database.azure.com:3306/exampledb?useSSL=true&requireSSL=false"
      "MYSQL_USER" = "mysqladminun@tflab-mysqlserver-1-teste.mysql.database.azure.com"
      "MYSQL_PASS" = "easytologin4once!"
    }
  }

  container {
    name   = "reportsapi"
    image  = "bootcampici.azurecr.io/reportsapi:latest"
    cpu    = "0.5"
    memory = "1.5"
    
    ports {
      port     = 82
      protocol = "TCP"
    }

    environment_variables = {
      "MYSQL_URL" = "jdbc:mysql://tflab-mysqlserver-1-teste.mysql.database.azure.com:3306/exampledb?useSSL=true&requireSSL=false"
      "MYSQL_USER" = "mysqladminun@tflab-mysqlserver-1-teste.mysql.database.azure.com"
      "MYSQL_PASS" = "easytologin4once!"
    }
  }

  depends_on = [
    azurerm_container_registry.bootcampici,
    null_resource.build_images,
    null_resource.upload_images
  ]
}