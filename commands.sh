# Databases
docker run -d -p 27017:27017 mongo
docker run -d -p 1433:1433 -e ACCEPT_EULA=Y -e SA_PASSWORD=Teste@admin123 mcr.microsoft.com/mssql/server:2019-latest

# MongoDb (CandidatesAPI)
dotnet add package MongoDB.Driver

# Entity Framework (VotesAPI)
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet tool install -g dotnet-ef
dotnet add package Microsoft.EntityFrameworkCore.Design
export PATH="$PATH:/home/vscode/.dotnet/tools"
dotnet ef migrations add InitialCreate
dotnet ef database update

# Publish
cd CandidatesAPI
dotnet publish -c Release -o ./publish
cd ../VotesAPI
dotnet publish -c Release -o ./publish

# Azure Function
Install Azure function tools

func init CountingFunction
func new --template "Service Bus Queue Trigger" --name CountingTrigger

Criar CosmosDB for MongoDB
Criar SQL Databases
Criar Azure Container Registry
    Permitir admin user
Criar Service Bus
    Criar Queue
Criar 3 Azure Container Instances
Criar Azure Function (Premium - Linux)

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