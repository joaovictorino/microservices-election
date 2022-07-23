## How to execute the election API sample using Docker and Azure Container Instances

### Prerequisites
- Azure account
- Docker
- Docker Compose
- VSCode
- Azure extension on VSCode
- .Net 6 SDK

### Architecture local with Docker Compose
![alt architecture](.documentation/container_local.jpg "Architecture")

Locally just run ```` docker compose up --build ```` at root folder.

First let's create an [Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal?tabs=azure-cli), inside Azure Portal.

Build docker images inside the project, tag them with registry name and push to private container registry Azure.
Now create the databases [Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/single-database-create-quickstart?view=azuresql&tabs=azure-portal) and [CosmosDB API MongoDB](https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/create-mongodb-java).

Using Azure, we have three simple ways to host containers, [Azure Container Instances](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-quickstart-portal), [Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/quickstart-dotnetcore?tabs=net60&pivots=development-environment-vs) and [Azure Container Apps](https://docs.microsoft.com/en-us/azure/container-apps/quickstart-portal). We have the diagrams bellow showing hosting application in all the services. Any options you choose, don't forget to set environment variables to connect to databases, variable's examples are inside docker compose file.

When we are using ACI, the simpler way is just run the APIs images, without Proxy Reverse. Although Azure App service are a good way to run two containers, API e Proxy Reverse together and Azure Container Apps comes with HTTP Ingress for basic control and support for multiples containers.

### Architecture with Azure App Service and Docker Compose
![alt architecture](.documentation/container_appservice.jpg "Architecture")

App Service is an PaaS Serveless, you can deploy only your code, using runtimes supported by Azure, or run containers. One App Service hosts more than one container, it's scales vertically and horizontally, also supports auto-scaling but you don't have fine control over network or deploy strategies.

### Architecture with Azure Container Instances and Docker Compose
![alt architecture](.documentation/container_aci.jpg "Architecture")

Azure Container Instances it's like to have your own Docker/Docker Compose at Azure, with the same features and limitations. ACI doesn't support auto-scaling or deploy strategies, but you have an environment similar to Docker local, like internal DNS.

### Architecture with Azure Container Apps
![alt architecture](.documentation/container_containerapps.jpg "Architecture")

Azure Container Apps is an Kubernetes without complexity, but not all features are available. Also you have KEDA and Dapr extensions for event-driven applications and a solution of side-car. Also supports auto scaling and some deploy strategies, like traffic splitting.