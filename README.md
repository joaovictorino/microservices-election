## How to execute the election API sample using Kong and KeyCloak

### Prerequisites
- Docker
- VSCode

### Architecture local with Docker Compose
![alt architecture](.documentation/apigateway_local.jpg "Architecture")

Locally just run ```` docker compose up --build ```` at root folder, and after run ```` docker compose run -it --rm kong kong migrations bootstrap ```` for Kong database migration.

Open KeyCloak address at [http://localhost:8180/](http://localhost:8180/), user: admin and password: admin. Follow the steps in the reference bellow to create realm named bootcamp, two clients and user at KeyCloak.

Create a client for Kong, change the fields bellow and save:

|  Id  |  Access type  | Service account |     Root url     | Validate redirect |
|------|---------------|-----------------|------------------|-------------------|
| kong | confidential  |     enabled     | http://kong:8000 |      /mock/*      |

Now create the second client for app:

|  Id  |  Validate redirect |
|------|--------------------|
| app  |        app         |

Finaly create the user, set the fields bellow and save:

|  Username |         E-mail         | First name | Last name  | E-mail verified |
|-----------|------------------------|------------|------------|-----------------|
|   joao    | jhvictorino@gmail.com  |    João    |  Victorino |       true      |

After go to credentials tab, fill password with Teste@admin123 and switch off temporary flag, click on Set Password.

[Reference](https://github.com/d4rkstar/kong-konga-keycloak)

## How to execute the election API sample using Azure APIM and Active Directory B2C

### Prerequisites
- Azure account
- Azure client (command-line)
- Docker
- VSCode
- Azure extension on VSCode
- [Azure Function Tools](https://docs.microsoft.com/pt-br/azure/azure-functions/functions-run-local?tabs=v4%2Clinux%2Ccsharp%2Cportal%2Cbash)
- .Net 6 SDK
- Terraform

### Architecture inside Azure
![alt architecture](.documentation/apigateway_azure.jpg "Architecture")

Go to Infrastructure/Terraform folder and execute commands bellow:

````sh
terraform init
terraform apply -auto-approve
````