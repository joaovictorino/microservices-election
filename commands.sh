# Create projects
dotnet new webapi -o CandidatesAPI
dotnet new webapi -o VotesAPI
dotnet new webapi -o ReportsAPI
dotnet new worker --name CountingWorker

# MongoDb (CandidatesAPI)
dotnet add package MongoDB.Driver

# Entity Framework (ReportsAPI)
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Microsoft.Extensions.Http.Polly
dotnet ef migrations add InitialCreate

# RabbitMQ (VotesAPI)
dotnet add package RabbitMQ.Client
dotnet add package Azure.Messaging.ServiceBus

# RabbitMQ (CountingWorker)
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package RabbitMQ.Client

# Docker Compose
docker compose up --build

# Create Azure Function (CountingFunction)
func init CountingFunction
func new --template "Service Bus Queue Trigger" --name CountingTrigger

# Create Azure Function Container
cd CountingFunction
docker build -t [registry]/countingfunction .
docker login [registry]
docker push [registry]/countingfunction

# Create Azure Function as Container from az-cli
az functionapp create -g [resource_group] -p [app_service_plan] -n countingfunction -s [storage_account] --deployment-container-image-name [registry/image] --docker-registry-server-password [admin_registry_password] --docker-registry-server-user [admin_registry]

# Set variables to Azure Function pull image from registry
# DOCKER_CUSTOM_IMAGE_NAME
# DOCKER_REGISTRY_SERVER_URL
# DOCKER_REGISTRY_SERVER_USERNAME
# DOCKER_REGISTRY_SERVER_PASSWORD