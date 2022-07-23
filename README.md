## How to execute the election API sample using Azure Container Instances and Azure Function

### Prerequisites
- Azure account
- Docker
- Docker Compose
- VSCode
- Azure extension on VSCode
- [Azure Function Tools](https://docs.microsoft.com/pt-br/azure/azure-functions/functions-run-local?tabs=v4%2Clinux%2Ccsharp%2Cportal%2Cbash)
- .Net 6 SDK

### Architecture local with Docker Compose
![alt architecture](.documentation/messaging_local.jpg "Architecture")

Locally just run ```` docker compose up --build ```` at root folder.

### Architecture inside Azure using Function
![alt architecture](.documentation/messaging_azure.jpg "Architecture")

First let's create an [Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal?tabs=azure-cli), inside Azure Portal.

Build docker images inside the project, tag them with registry name and push to private container registry Azure. This version of project has three images to push, CandidatesAPI, VotesAPI and ReportsAPI.

Now create the databases [Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/single-database-create-quickstart?view=azuresql&tabs=azure-portal) and [CosmosDB API MongoDB](https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/create-mongodb-java). Now we need a queue to store the votes, so create [Azure Service Bus](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-dotnet-get-started-with-queues).

At this time, we will host ours containers in [Azure Container Instances](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-quickstart-portal). When we are using ACI, the simpler way is just run the APIs images, without Proxy Reverse. 

Finally create [Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-get-started?pivots=programming-language-csharp) for .Net 6 environment inside Azure Portal, then inside VSCode Azure extension, find workspace click-right on CountingTrigger and click on Deploy to Function App. Don't forget to set SQL Azure and Service Bus connection string on Azure Function configuration inside the portal.

Now test the application!

### Hosting Azure Functions inside Container
Another option, is create Azure Function as container, execute the command bellow using az-cli to create the function:

````sh
az functionapp create -g [resource_group] -p [app_service_plan] -n countingfunction -s [storage_account] --deployment-container-image-name [registry/custom_container_image_name]
````

It's mandatory to set environment variables on Azure Function to pull images from ACR:

````sh
DOCKER_REGISTRY_SERVER_URL
DOCKER_REGISTRY_SERVER_USERNAME
DOCKER_REGISTRY_SERVER_PASSWORD
````

Azure Function Dockerfile is inside CountingFunction project, build and push image to registry.