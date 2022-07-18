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
# Install Azure function tools
func init CountingFunction
func new --template "Service Bus Queue Trigger" --name CountingTrigger