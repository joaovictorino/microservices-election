resource "azurerm_kubernetes_cluster" "bootcamp-aks" {
  name                = "bootcamp-aks"
  location            = azurerm_resource_group.bootcamp.location
  resource_group_name = azurerm_resource_group.bootcamp.name
  dns_prefix          = "bootcamp-k8s"
  http_application_routing_enabled = true
  role_based_access_control_enabled = true

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

// az aks get-credential
// apply k8s terraform integration k8s.tf
// apply k8s files k8s.tf