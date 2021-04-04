# tf-azure-multitier-app-template
# 3-tier Application infrastructuretemplate module

## Architecture Overview

![Alt text](AKS%20Architecture.png?raw=true "AKS Architecture Overview")
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

Available in Terraform Public Registry:

https://registry.terraform.io/modules/danielvelasquez/multitier-app-template/azurerm/latest

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

In order to provision the additional resources needed to use the remote backend I provided this additional module (WIP):

https://github.com/danielvelasquez/terraform-azurerm-backend-config

Available in Terraform  Registry:

https://registry.terraform.io/modules/danielvelasquez/backend-config/azurerm/latest

## Access Management Considerations

Provisioning of azure key-vault for top level secrets is out of scope for this assignment, instead all credentials and secrets to access the subscription are stored as CI/CD masked variables which means they won't be accidentally printed in console logs on GitLab and only project Maintainers have access to them, for secrets inside the cluster like database credentials and app insights a kubernetes secret resource is provisioned in the module.
## Module Release Pipeline

This module is tested and released using GitLab CI mirroring repo: 

https://gitlab.com/danielrvelasquez/terraform-azurerm-multitier-app-template

Pipeline Code:

https://gitlab.com/danielrvelasquez/pipelines

The pipelines are declared in a separate repo so maximize usability, the pipelines repo contains a template for common stages across projects and technologies and implementation pipelines that define how each type should be released.

The module project contains a .gitlab-ci.yml file which references the template pipeline and the specific multitier application infrastructure provisioning pipeline.

Each job is executed in a docker container with all the necessary tools (f.ex go, terraform cli, azure cli, git, curl, etc...). This enhances reliability and reusability in the CI/CD pipeline, furthermore some easy enhancements can be made in order to provide a string with values for variables as a CI/CD variable in gitlab to make this pipeline work for any terraform module.