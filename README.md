## How to execute the election API sample using Kong and KeyCloak

### Prerequisites
- Docker
- VSCode

### Architecture local with Docker Compose
![alt architecture](.documentation/apigateway_local.jpg "Architecture")

Locally just run ```` docker compose up --build ```` at root folder.

## How to execute the election API sample using Azure APIM and Active Directory B2C

### Prerequisites
- Azure account
- Azure Client (command-line)
- Docker
- VSCode
- Azure extension on VSCode
- [Azure Function Tools](https://docs.microsoft.com/pt-br/azure/azure-functions/functions-run-local?tabs=v4%2Clinux%2Ccsharp%2Cportal%2Cbash)
- .Net 6 SDK
- Terraform

### Architecture inside Azure
![alt architecture](.documentation/apigateway_azure.jpg "Architecture")