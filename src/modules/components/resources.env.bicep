// ------
// Scopes
// ------

targetScope = 'resourceGroup'

// ---------
// Resources
// ---------

resource storage 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: lifecycle.resourceName
  location: config.location
  sku: {
    name: 'Standard_RAGRS'
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: true
  }
}

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: lifecycle.resourceName
  location: config.location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    azureADOnlyAuthentication: true
    managedResourceGroupName: lifecycle.managedResourceGroup
    defaultDataLakeStorage: {
      resourceId: storage.id
      accountUrl: storage.properties.primaryEndpoints.dfs
      filesystem: 'default'
    }
  }
}

resource vault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: lifecycle.resourceName
  location: config.location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    accessPolicies: []
    createMode: 'recover'
  }
}

// ----------
// Parameters
// ----------

param config object
param lifecycle object
