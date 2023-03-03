## Using KV Module

Following example tells you one way of using this module

```
param shortAppName string = 'myapp'
@allowed([
  'poc'
  'dev'
])
param env string = 'poc'
param appPrefix string= '${shortAppName}-${env}'
param location string = 'West Europe'
param locationWithoutSpaces string = toLower(replace(location, ' ', ''))
param trimmedString string = substring(uniqueString(resourceGroup().id), 0, 3)
param yourobjID string = 'Pass your object id if you need list access right away'

module keyVaultModule 'module.bicep' = {
  name: 'keyVaultModule'
  params: {
    keyVaultName: 'kv-${appPrefix}-${trimmedString}'
    location: location
    envName: env
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: yourobjID
        permissions: {
          keys: [
            'List'
            'Get'
          ]
          secrets: [
            'List'
            'Get'
          ]
          certificates: []
        }
      }
    ]
    kvSecretname: [
      {
        SecName: 'dummy1'
        SecValue: 'test'
      }
      {
        SecName: 'dummy2'
        SecValue: 'test'
      }
    ]
  }
}
```
