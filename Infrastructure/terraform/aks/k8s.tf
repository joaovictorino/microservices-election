provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.default.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.bootcamp-aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.bootcamp-aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.bootcamp-aks.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "bootcamp" {
  metadata {
    name = "bootcamp"
  }

  depends_on = [
      null_resource.get_credentials
    ]   
}

resource "kubernetes_config_map" "bootcamp" {
  metadata {
    name = "bootcamp-configmap"
    namespace = kubernetes_namespace.bootcamp.metadata[0].name
  }

  data = {
    ASPNETCORE_ENVIRONMENT="Production"
    ASPNETCORE_CandidateDatabase__DatabaseName="Candidates"
    ASPNETCORE_CandidateDatabase__ConnectionString=module.solution.azurerm_cosmosdb_account.connection_strings[0]
    ASPNETCORE_ConnectionStrings__VotesDatabase="Server=tcp:${module.solution.azurerm_mssql_server.fully_qualified_domain_name},1433;Initial Catalog=${module.solution.azurerm_mssql_database.name};Persist Security Info=False;User ID=${module.solution.azurerm_mssql_server.administrator_login};Password=${module.solution.azurerm_mssql_server.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    ASPNETCORE_Azure="true"
    ASPNETCORE_RabbitMQ=module.solution.azurerm_servicebus_namespace.default_primary_connection_string
    ASPNETCORE_Integrations__CandidateAddress="http://candidates-svc/api/candidates/"
  }

  depends_on = [
      null_resource.get_credentials,
      kubernetes_namespace.bootcamp
    ]
}

resource "null_resource" "apply_kube_files" {
    triggers = {
        order = kubernetes_config_map.bootcamp.id
    }

    provisioner "local-exec" {
      working_dir = "${path.module}/../../"
      command = "kubectl apply -f k8s"
    }
}