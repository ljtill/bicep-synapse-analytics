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
    minimumTlsVersion: 'TLS1_2'
  }
}
resource blob 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  parent: storage
  name: 'default'
  properties: {}
}
resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: blob
  name: 'default'
  properties: {
    publicAccess: 'None'
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
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
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
    createMode: 'default'
    enableSoftDelete: false
  }
}

// Role Assignments

resource storageAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storage.name, 'Storage')
  scope: storage
  properties: {
    principalType: 'ServicePrincipal'
    principalId: workspace.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe') // NOTE: Storage Blob Data Contributor
  }
}
resource groupAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid(workspace.name, 'Synapse')
  scope: workspace
  properties: {
    principalType: 'ServicePrincipal'
    principalId: workspace.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // NOTE: Contributor
  }
}

// ----------
// Parameters
// ----------

param config object
param lifecycle object
