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

Alternatively, the backend can be configured to an http endpoint, for GitLab projects gitlab provides an easy configuration to store the terraform state files:

https://docs.gitlab.com/ee/user/infrastructure/

The following project uses this module to provision the infrastructure in aks and uses GitLab as the http backend:

https://gitlab.com/danielrvelasquez/sample-app/

## Local Development

Since the cluster is provisioned as a Kubernetes cluster it can easily be replicated locally using minikube deploying applications with helm charts.

Development workstation requirements:

Kubernetes + Docker
Helm


The reference application mentioned a few sections below illustrates how the application can be set up for ease of deployment using helm charts.
## AKS Cluster Scalability

The aks cluster provisioned is set to be auto-scalable but it also has limits configured based on namespaces, meaning environments for different stages even within the same cluster will scale up to the limits given by the stage namespace, currently the namespaces provided are dev, uat and prod, the namespaces can also be provisioned and configured dynamically to allow multiple namespaces for the same application in the same stage (multiple dev or uat environments). 
## Access Management Considerations

Provisioning of azure key-vault for top level secrets is out of scope for this assignment, instead all credentials and secrets to access the subscription are stored as CI/CD masked variables which means they won't be accidentally printed in console logs on GitLab and only project Maintainers have access to them, for secrets inside the cluster like database credentials and app insights a kubernetes secret resource is provisioned in the module.

Currently a named space is used on GitLab.com for the mirroring repositories but they can be put in a group so that default access variables can be shared and RBAC finely implemented at both group and project level
## Module Release Pipeline

This module is tested and released using GitLab CI mirroring repo: 

https://gitlab.com/danielrvelasquez/terraform-azurerm-multitier-app-template

Pipeline Code:

https://gitlab.com/danielrvelasquez/pipelines

The pipelines are declared in a separate repository to maximize usability. The pipelines repo contains a template for common stages across projects and technologies and implementation pipelines that define how each type should be released. 

The module project contains a .gitlab-ci.yml file which references the template pipeline and the specific multitier application infrastructure provisioning pipeline.

Each job is executed in a docker container with all the necessary tools (f.ex go, terraform cli, azure cli, git, curl, etc...). This enhances reliability and reusability in the CI/CD pipeline, furthermore some easy enhancements can be made in order to provide a string with values for variables as a CI/CD variable in gitlab to make this pipeline work for any terraform module.

Notes on Performance: The pipeline performance can further be improved by caching modules, paralelizing steps and improving the images used but performance tunning is out of the scope for this assignment. 
## Pipeline reliability

The release pipeline deploys and tests the module using Terratest and TFSec, Terratest provisions the infrastructure, performs assertions and proceed to destroy the resources created. The provisioning happens on a free trial Microsoft Azure account which limits the amount of nodes so that only one cluster can exist at the time, therefore if the reference app has been deployed the dynamic tests for the module will fail and a new release won't be made until Terraform can successfully apply the changes and pass the dynamic tests.
## Reference Application

The Following Application is deployed by implementing the terraform module to provision the kubernetes cluster on aks and installing a set of helm charts. The pipeline has not been made generic nor takes into account multiple namespaces for different stages but it exemplifies how it all ties together in order to make use of the module:

https://gitlab.com/danielrvelasquez/sample-app

Pipeline code:

Infrastructure provisioning

https://gitlab.com/danielrvelasquez/pipelines/-/blob/master/.ci-terraform-multitier-app.yml

Application Deployment

https://gitlab.com/danielrvelasquez/pipelines/-/blob/master/.ci-aks-multilayer-app.yml

Next steps:

The deployment pipeline can be further extended to use the namespaces and declare jobs to deploy on different environments per stage, add an approval flow to work with the branching strategy, add automated tests and find helm charts instead of expliscitly declaring them in the deployment job, so that it can be used for any multilayer app and not just the reference one but those improvements are out of the scope for this assignment.