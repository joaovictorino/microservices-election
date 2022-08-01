resource "azurerm_kubernetes_cluster" "bootcamp-aks" {
  name                = "bootcamp-aks"
  location            = azurerm_resource_group.bootcamp.location
  resource_group_name = azurerm_resource_group.bootcamp.name
  dns_prefix          = "bootcamp-k8s"
  http_application_routing_enabled = true

  default_node_pool {
    name            = "default"
    node_count      = 3
    vm_size         = "Standard_D3_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }
}

data "azuread_service_principal" "aks_principal" {
  application_id = var.appId
}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = module.solution.azurerm_container_registry.id
  role_definition_name             = "AcrPull"
  principal_id                     = data.azuread_service_principal.aks_principal.id
  skip_service_principal_aad_check = true
}

resource "null_resource" "get_credentials" {
    triggers = {
        order = azurerm_kubernetes_cluster.bootcamp-aks.id
    }

    provisioner "local-exec" {
      command = "az aks get-credentials --resource-group ${azurerm_resource_group.bootcamp.name} --name ${azurerm_kubernetes_cluster.bootcamp-aks.name} --overwrite-existing"
    }

    depends_on = [
      azurerm_kubernetes_cluster.bootcamp-aks
    ]
}

data "azurerm_kubernetes_cluster" "default" {
  name                = azurerm_kubernetes_cluster.bootcamp-aks.name
  resource_group_name = azurerm_resource_group.bootcamp.name

  depends_on = [
    azurerm_kubernetes_cluster.bootcamp-aks
  ]
}