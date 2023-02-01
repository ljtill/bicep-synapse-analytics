# Synapse

Azure Synapse Analytics is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics. It gives you the freedom to query data on your terms, using either serverless or dedicated options—at scale. Azure Synapse brings these worlds together with a unified experience to ingest, explore, prepare, transform, manage, and serve data for immediate BI and machine learning needs.

This repository contains the infra-as-code components to quickly scaffold a new Azure Synapse Analytics environment.

_Please note these artifacts are under development and subject to change._

---

### Getting Started

Before deploying the Azure Synapse resources, the parameters file `src/parameters/main.json` needs to be updated.

#### Using locally with Azure CLI

```bash
az deployment sub create \
    --name 'Microsoft.Bicep' \
    --location 'uksouth' \
    --template-file './src/main.bicep' \
    --parameters \
      '@./src/parameters/main.json'
```

#### Using with GitHub Actions

Azure Active Directory - Application

- Navigate to the 'App Registration' blade wihin the Azure portal
- Select 'New registration' and provide a Name for the application
- Select the newly created application and select 'Certificates & secrets'
- Select 'Federated Credentials' and 'Add credential'
- Provide the 'Organization (username)' and Repository for the credential
- Select 'Entity type' - Branch and provide 'main'
- Repeat process for 'Entity type' - Pull Request

Azure Resource Manager - Role Assignment

- Navigate to the Subscription in the Azure portal
- Select 'Access control (IAM)' and 'Add' - 'Add role assignment'
- Select Role - Contributor and select 'Members'
- Provide the 'Name' of the application from the previous steps

GitHub Actions - Secrets

- Navigate to 'Settings' on the repository
- Select 'Secrets' and 'Actions' link
- Select 'New repository secret' and create secrets for the following:
  - AZURE_TENANT_ID
  - AZURE_SUBSCRIPTION_ID
  - AZURE_CLIENT_ID

---

### Links

- [Synapse](https://azure.microsoft.com/products/synapse-analytics/)
- [Bicep](https://github.com/Azure/bicep)
- [Templates](https://learn.microsoft.com/azure/templates/)
