// keyvault module

@description('KeyVault Name: ')
param keyVaultName string
@description('Azure Region: ')
param location string
@description('Access Policies: ')
param accessPolicies array
@description('Environment Name:')
param envName string
@description('KV Secret: ')
param kvSecretname array = [
  {
    SecName: 'sec1'
    SecValue: 'dummy2'
  }
  {
    SecName: 'sec1'
    SecValue: 'dummy2'
  }
]

resource keyVault 'Microsoft.KeyVault/vaults@2022-11-01' = {
  name: keyVaultName
  location: location
  tags: {
    env: envName
  }
  properties: {
    sku: {
      family: 'A'
      name: 'Standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: accessPolicies

  }
}

resource kvSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' =[for iSecret in kvSecretname: {
  name: iSecret.SecName
  tags: {
    env: envName
  }
  parent: keyVault
  properties: {
    // attributes: {
    //   enabled: bool
    //   exp: int
    //   nbf: int
    // }
    contentType: 'string'
    value: iSecret.SecValue
  }
}]

output keyVaultId string = keyVault.id
output vaultUri string = 'https://${keyVault.name}.vault.azure.net'
