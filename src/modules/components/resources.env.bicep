// ------
// Scopes
// ------

targetScope = 'resourceGroup'

// ---------
// Resources
// ---------

// Storage Accounts

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

// Synapse Workspaces

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
resource workspaceRule 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = {
  parent: workspace
  name: 'default'
  properties: {
    startIpAddress: config.clientAddress
    endIpAddress: config.clientAddress
  }
}

// Key Vaults

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
