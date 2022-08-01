resource "local_file" "create_configmap_k8s" {
    filename = "./k8s/2-configmap.yaml"
    content     = <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: bootcamp-configmap
  namespace: bootcamp
data:
  ASPNETCORE_Azure: "true"
  ASPNETCORE_CandidateDatabase__ConnectionString: "${module.solution.azurerm_cosmosdb_account.connection_strings[0]}"
  ASPNETCORE_CandidateDatabase__DatabaseName: "Candidates"
  ASPNETCORE_ConnectionStrings__VotesDatabase: "Server=tcp:${module.solution.azurerm_mssql_server.fully_qualified_domain_name},1433;Initial Catalog=${module.solution.azurerm_mssql_database.name};Persist Security Info=False;User ID=${module.solution.azurerm_mssql_server.administrator_login};Password=${module.solution.azurerm_mssql_server.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  ASPNETCORE_ENVIRONMENT: "Production"
  ASPNETCORE_Integrations__CandidateAddress: "http://candidates-svc/api/candidates/"
  ASPNETCORE_RabbitMQ: "Endpoint=${module.solution.azurerm_servicebus_namespace.default_primary_connection_string}"
EOF
    depends_on = [ 
      null_resource.get_credentials,
      module.solution.azurerm_cosmosdb_account,
      module.solution.azurerm_mssql_server,
      module.solution.azurerm_mssql_database,
      module.solution.azurerm_servicebus_namespace
    ]
}

resource "null_resource" "apply_kube_files" {
    triggers = {
        order = local_file.create_configmap_k8s.id
    }

    provisioner "local-exec" {
      command = "kubectl apply -f k8s"
    }
}