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

# Kong e Keycloak
docker-compose run -it kong kong migrations bootstrap

# Keycloak 
admin/admin

# install plugins
curl -s -X POST http://localhost:8001/plugins \
  -d name=oidc \
  -d config.client_id=kong \
  -d config.client_secret=x0KPu2n0bIQxyg78HNcRERFyKmu83Kdr \
  -d config.bearer_only=yes \
  -d config.realm=bootcamp \
  -d config.introspection_endpoint=http://172.19.0.12:8080/realms/bootcamp/protocol/openid-connect/token/introspect \
  -d config.discovery=http://172.19.0.12:8080/auth/realms/bootcamp/.well-known/openid-configuration

# get token
curl -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "username=joao" \
        -d "password=teste" \
        -d 'grant_type=password' \
        -d "client_id=app" \
        http://172.19.0.12:8080/realms/bootcamp/protocol/openid-connect/token 

# access with token
curl http://localhost:8000/reports -H "Authorization: Bearer {JWT}"
curl http://localhost:8000/votes -H "Authorization: Bearer {JWT}"
curl http://localhost:8000/candidates -H "Authorization: Bearer {JWT}"