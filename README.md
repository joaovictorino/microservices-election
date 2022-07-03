## How to execute the election API sample on Azure

### Prerequisites
- Azure account
- VSCode
- Azure App Service extension on VSCode
- .Net 6 SDK

### Architecture
![alt architecture](.documentation/microservices_paas.jpg "Architecture")

Go to Azure Portal and create the two databases, [Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/single-database-create-quickstart?view=azuresql&tabs=azure-portal) and [CosmosDB API MongoDB](https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/create-mongodb-java).

After all databases is running, go to CandidatesAPI folder in the appsettings.json file, and change the connection string of CosmosDB, you can get the connection string in Azure Portal. Do the same for VotesAPI, changing the connection string of SQL Server.

Next step is to create two [Web Apps](https://docs.microsoft.com/en-us/azure/app-service/quickstart-dotnetcore?tabs=net60&pivots=development-environment-vscode) on Azure and publish the APIs.