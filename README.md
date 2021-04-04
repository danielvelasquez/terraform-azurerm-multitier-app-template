# tf-azure-multitier-app-template
# 3-tier Application infrastructuretemplate module

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.54.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.54.0 |

## Usage:
~~~

module "cluster" {
  source                       = "github.com/danielvelasquez/terraform-azurerm-multitier-app-template?ref=<tag>"
  subscription_id              = var.subscription_id
  backend_client_id            = var.backend_client_id
  backend_client_secret        = var.backend_client_secret
  backend_ssh_key              = var.backend_ssh_key
  location                     = var.location
  kubernetes_version           = var.kubernetes_version
  resource_group_name          = var.resource_group_name
  environment                  = var.environment
  tenant_id                    = var.tenant_id 
  db_name                      = var.db_name
}

~~~


## Considerations

To increase reliability at scale it is recommended to use a remote backend independent from the provisioning system, this can be done by adding the following blosk to the main terraform file consuming the module:

~~~

terraform {
    backend "azurerm" {

    }
}

~~~

In conjunction the backend configuration values need to be passed to the terraform init command:

~~~
terraform init \
          -reconfigure \
          -backend-config resource_group_name=<Storage account resource group name> \ 
          -backend-config storage_account_name=<Storage account name> \
          -backend-config container_name=<container name> \
          -backend-config key=<Backend config key> \
          -backend-config subscription_id=<Subscription Id> \
          -backend-config tenant_id=<Tenant Id> \
          -backend-config client_id=<Backend Client ID (SP)> \
          -backend-config client_secret=<Backend Client Secret>
~~~

## Module Release Pipeline

This module is tested and released using GitLab CI mirroring repo: 

https://gitlab.com/danielrvelasquez/terraform-azurerm-multitier-app-template

Pipeline Code:

https://gitlab.com/danielrvelasquez/pipelines