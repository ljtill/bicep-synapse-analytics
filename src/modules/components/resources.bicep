// ------
// Scopes
// ------

targetScope = 'resourceGroup'

// -------
// Modules
// -------

// Sandbox

module resources 'resources.env.bicep' = [for (environment, count) in settings.environments: {
  name: 'Microsoft.Resources.Environment.${count}'
  params: {
    defaults: defaults
    settings: settings
    environment: environment
  }
}]

// ----------
// Parameters
// ----------

param defaults object
param settings object
