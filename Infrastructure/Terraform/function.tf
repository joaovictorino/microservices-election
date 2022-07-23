resource "azurerm_storage_account" "bootcamp" {
  name                     = "countingfunctionsa"
  resource_group_name      = azurerm_resource_group.bootcamp.name
  location                 = azurerm_resource_group.bootcamp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "countingfunction" {
  name                    = "countingfunction-premiumPlan"
  resource_group_name     = azurerm_resource_group.bootcamp.name
  location                = azurerm_resource_group.bootcamp.location
  os_type                 = "Linux"
  sku_name                = "B1"
}

resource "azurerm_linux_function_app" "countingfunction" {
    name                        = "countingfunction"
    location                    = azurerm_resource_group.bootcamp.location
    resource_group_name         = azurerm_resource_group.bootcamp.name
    storage_account_name        = azurerm_storage_account.bootcamp.name
    service_plan_id             = azurerm_service_plan.countingfunction.id
    functions_extension_version = "~4"

    app_settings = {
        FUNCTION_APP_EDIT_MODE                    = "readOnly"
        https_only                                = true
        ServiceBusConnection                      = azurerm_servicebus_namespace.bootcamp.default_primary_connection_string
        DOCKER_REGISTRY_SERVER_URL                = "https://${azurerm_container_registry.bootcampici.login_server}/"
        DOCKER_REGISTRY_SERVER_USERNAME           = azurerm_container_registry.bootcampici.admin_username
        DOCKER_REGISTRY_SERVER_PASSWORD           = azurerm_container_registry.bootcampici.admin_password
        WEBSITES_ENABLE_APP_SERVICE_STORAGE       = false
    }

    connection_string {
        name = "SqlConnectionString"
        type = "SQLAzure"
        value = "Server=tcp:${azurerm_mssql_server.votessrv.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.votesdb.name};Persist Security Info=False;User ID=${azurerm_mssql_server.votessrv.administrator_login};Password=${azurerm_mssql_server.votessrv.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    }

    site_config {
      always_on         = true
      application_stack {
        docker {
            registry_url      = azurerm_container_registry.bootcampici.login_server
            image_name        = "bootcampici.azurecr.io/countingfunction"
            image_tag         = "latest"
            registry_username = azurerm_container_registry.bootcampici.admin_username
            registry_password = azurerm_container_registry.bootcampici.admin_password
        }
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