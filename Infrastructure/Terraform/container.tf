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
      "ASPNETCORE_ENVIRONMENT" = "Production"
      "ASPNETCORE_CandidateDatabase__DatabaseName" = "Candidates"
      "ASPNETCORE_CandidateDatabase__ConnectionString" = azurerm_cosmosdb_account.candidatesdb.connection_strings[0]
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
      "ASPNETCORE_ENVIRONMENT" = "Production"
      "ASPNETCORE_URLS" = "http://+:82"
      "ASPNETCORE_ConnectionStrings__VotesDatabase" = "Server=tcp:${azurerm_mssql_server.votessrv.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.votesdb.name};Persist Security Info=False;User ID=${azurerm_mssql_server.votessrv.administrator_login};Password=${azurerm_mssql_server.votessrv.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

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
      "ASPNETCORE_ENVIRONMENT" = "Production"
      "ASPNETCORE_URLS" = "http://+:81"
      "ASPNETCORE_Azure" = "true"
      "ASPNETCORE_RabbitMQ" = azurerm_servicebus_namespace.bootcamp.default_primary_connection_string
      "ASPNETCORE_Integrations__CandidateAddress" = "http://localhost/api/candidates/"
    }
  }

  depends_on = [
      azurerm_container_registry.bootcampici,
      azurerm_cosmosdb_account.candidatesdb,
      azurerm_cosmosdb_mongo_database.candidatesdb,
      azurerm_servicebus_namespace.bootcamp,
      azurerm_servicebus_queue.votesmq,
      azurerm_mssql_server.votessrv,
      azurerm_mssql_database.votesdb,
      null_resource.build_images,
      null_resource.upload_images
    ] 
}