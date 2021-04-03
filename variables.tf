variable "subscription_id" {
  description = "Azure subscription identifier"
}

variable "backend_client_id" {
  description = "Service principal used to provision resources"
}

variable "backend_client_secret" {
  description = "Service Principal Key for authentication"
}

variable "tenant_id" {
  description = "Tenant identifier on azure"
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Location for provisioned resources"
}

variable "kubernetes_version" {
  default     = "1.19.6"
  description = "TKubernetes version used for aks cluster"
}

variable "backend_ssh_key" {
  description = "ssh key to authenticate to backend"
}

variable "resource_group_name" {
  description = "Name of the resource group to be created for each consuming project"
}

variable "prefix" {
  default     = "leo"
  description = "Prefix for resource naming conventions"
}

variable "display_name_prefix" {
  default     = "leo-pharma"
  description = "Display name prefix"
}

variable "environment" {
  description = "Environment/stage used by consuming project to provision"
}

#################### from k8s

variable "db_name" {
  description = "Name of database resource for the consuming project"
}