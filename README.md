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
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.70 |

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