resource "null_resource" "build_images" {
    provisioner "local-exec" {
      working_dir = "${path.module}/../../../"
      command = <<-EOT
        docker build -t bootcampici.azurecr.io/candidatesapi ./CandidatesAPI && 
        docker build -t bootcampici.azurecr.io/reportsapi ./ReportsAPI && 
        docker build -t bootcampici.azurecr.io/votesapi ./VotesAPI && 
        docker build -t bootcampici.azurecr.io/countingfunction ./CountingFunction
      EOT
    }
}

resource "null_resource" "upload_images" {
    triggers = {
        order = azurerm_container_registry.bootcampici.id
    }

    provisioner "local-exec" {
      command = <<-EOT
        az acr login --name bootcampici &&
        docker push bootcampici.azurecr.io/candidatesapi:latest &&
        docker push bootcampici.azurecr.io/votesapi:latest &&
        docker push bootcampici.azurecr.io/reportsapi:latest &&
        docker push bootcampici.azurecr.io/countingfunction:latest
      EOT
    }

    depends_on = [
      azurerm_container_registry.bootcampici,
      null_resource.build_images
    ]
}