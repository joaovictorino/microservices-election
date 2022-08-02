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
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "bootcamp" {
  name     = "bootcamp-containerapps"
  location = "eastus"
}

module solution {
  source = "../solution"
  resource_group = azurerm_resource_group.bootcamp
}

resource "local_file" "create_bicep_file" {
    filename = "./config.json"
    content     = <<EOF
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "location": {
      "value": "${azurerm_resource_group.bootcamp.location}"
    },
    "candidatesDatabase": {
      "value": "${module.solution.azurerm_cosmosdb_account.connection_strings[0]}"
    },
    "serverRegistry": {
      "value": "${module.solution.azurerm_container_registry.login_server}"
    },
    "adminUsernameRegistry": {
      "value": "${module.solution.azurerm_container_registry.admin_username}"
    },
    "adminPasswordRegistry": {
      "value": "${module.solution.azurerm_container_registry.admin_password}"
    },
    "votesDatabase": {
      "value": "Server=tcp:${module.solution.azurerm_mssql_server.fully_qualified_domain_name},1433;Initial Catalog=${module.solution.azurerm_mssql_database.name};Persist Security Info=False;User ID=${module.solution.azurerm_mssql_server.administrator_login};Password=${module.solution.azurerm_mssql_server.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    },
    "queue": {
      "value": "${module.solution.azurerm_servicebus_namespace.default_primary_connection_string}"
    },
    "environmentName":{
      "value": "bootcamp-containerapps"
    }
  }
}
EOF
    depends_on = [ 
      module.solution.azurerm_cosmosdb_account,
      module.solution.azurerm_mssql_server,
      module.solution.azurerm_mssql_database,
      module.solution.azurerm_servicebus_namespace
    ]
}

resource "null_resource" "create_containerapps_bicep" {
    triggers = {
        order = local_file.create_bicep_file.id
    }

    provisioner "local-exec" {
      command =<<EOT
az deployment group create --resource-group "${azurerm_resource_group.bootcamp.name}" --template-file ./containerapps.bicep --parameters @config.json
EOT
    }
}