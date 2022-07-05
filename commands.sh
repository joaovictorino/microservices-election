# Create projects
dotnet new webapi -o CandidatesAPI
dotnet new webapi -o VotesAPI

# MongoDb (CandidatesAPI)
dotnet add package MongoDB.Driver

# Entity Framework (VotesAPI)
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Microsoft.Extensions.Http.Polly
dotnet ef migrations add InitialCreate

# Databases using Docker
docker run -d -p 27017:27017 mongo
docker run -d -p 1433:1433 -e ACCEPT_EULA=Y -e SA_PASSWORD=Teste@admin123 mcr.microsoft.com/mssql/server:2019-latest

# Create database and table
dotnet tool install -g dotnet-ef
export PATH="$PATH:/home/vscode/.dotnet/tools"
dotnet ef database update

# Generate folder to publish
cd CandidatesAPI
dotnet publish -c Release -o ./publish
cd ../VotesAPI
dotnet publish -c Release -o ./publish

# Docker Compose
docker compose -f docker-compose-azure.yaml up