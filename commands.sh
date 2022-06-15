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