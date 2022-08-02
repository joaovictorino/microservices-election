param environmentName string
param location string
param serverRegistry string
param adminUsernameRegistry string
@secure()
param adminPasswordRegistry string
param candidatesDatabase string 
param votesDatabase string
param queue string

var logAnalyticsWorkspaceName = 'logs-${environmentName}'

resource logAnalyticsWorkspace'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

resource environment 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: environmentName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: reference(logAnalyticsWorkspace.id, '2020-03-01-preview').customerId
        sharedKey: listKeys(logAnalyticsWorkspace.id, '2020-03-01-preview').primarySharedKey
      }
    }
  }
}

resource candidatesApiContainerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'candidatesapi'
  location: location
  properties: {
    managedEnvironmentId: environment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
      registries: [
        {
          server: serverRegistry
          username: adminUsernameRegistry
          passwordSecretRef: 'container-registry-password'
        }
      ]
      secrets: [
        {
          name: 'container-registry-password'
          value: adminPasswordRegistry
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'candidatesapi'
          image: 'bootcampici.azurecr.io/candidatesapi:latest'
          env: [
            {
              name: 'ASPNETCORE_ENVIRONMENT'
              value: 'Production'
            }
            {
              name: 'ASPNETCORE_CandidateDatabase__DatabaseName'
              value: 'Candidates'
            }
            {
              name: 'ASPNETCORE_CandidateDatabase__ConnectionString'
              value: candidatesDatabase
            }
          ]
          resources: {
            cpu: 1
            memory: '2Gi'
          }         
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 2
      }
    }
  }
}

resource votesApiContainerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'votesapi'
  location: location
  properties: {
    managedEnvironmentId: environment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
      registries: [
        {
          server: serverRegistry
          username: adminUsernameRegistry
          passwordSecretRef: 'container-registry-password'
        }
      ]
      secrets: [
        {
          name: 'container-registry-password'
          value: adminPasswordRegistry
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'votesapi'
          image: 'bootcampici.azurecr.io/votesapi:latest'
          env: [
            {
              name: 'ASPNETCORE_ENVIRONMENT'
              value: 'Production'
            }
            {
              name: 'ASPNETCORE_Azure'
              value: 'true'
            }
            {
              name: 'ASPNETCORE_RabbitMQ'
              value: queue
            }
            {
              name: 'ASPNETCORE_Integrations__CandidateAddress'
              value: 'https://${candidatesApiContainerApp.properties.configuration.ingress.fqdn}/api/candidates/'
            }
          ]
          resources: {
            cpu: 1
            memory: '2Gi'
          }         
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 2
      }
    }
  }
}

resource reportsApiContainerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'reportsapi'
  location: location
  properties: {
    managedEnvironmentId: environment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
      registries: [
        {
          server: serverRegistry
          username: adminUsernameRegistry
          passwordSecretRef: 'container-registry-password'
        }
      ]
      secrets: [
        {
          name: 'container-registry-password'
          value: adminPasswordRegistry
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'reportsapi'
          image: 'bootcampici.azurecr.io/reportsapi:latest'
          env: [
            {
              name: 'ASPNETCORE_ENVIRONMENT'
              value: 'Production'
            }
            {
              name: 'ASPNETCORE_ConnectionStrings__VotesDatabase'
              value: votesDatabase
            }
          ]
          resources: {
            cpu: 1
            memory: '2Gi'
          }         
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 2
      }
    }
  }
}
