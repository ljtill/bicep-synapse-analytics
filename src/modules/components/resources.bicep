// ------
// Scopes
// ------

targetScope = 'resourceGroup'

// -------
// Modules
// -------

// Sandbox

module resources 'resources.env.bicep' = [for (lifecycle, count) in config.lifecycles: {
  name: 'Microsoft.Resources.Environment.${count}'
  params: {
    config: config
    lifecycle: lifecycle
  }
}]

// ---------
// Variables
// ---------

var defaults = loadJsonContent('../../defaults.json')

// ----------
// Parameters
// ----------

param config object
