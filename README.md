### Architecture with Azure Kubernetes Service
![alt architecture](.documentation/aks.jpg "Architecture")

Azure Kubernetes Service is an Kubernetes full-featured with Azure services integrations, like disks, load balancers, etc.

To test the application execute the command bellow and keep the output

````sh
az ad sp create-for-rbac
````

Inside the folder Infrastructure/terraform/aks create the file "terraform.tfvars" with the following content, replace the values with the result of the command above

````sh
appId=""
password=""
````

### Architecture with Azure Container Apps
![alt architecture](.documentation/containerapps.jpg "Architecture")

Azure Container Apps is an Kubernetes without complexity, but not all features are available. Also you have KEDA and Dapr extensions for event-driven applications and a solution of side-car. Also supports auto scaling and some deploy strategies, like traffic splitting.