variable "subscription_id" {
}

variable "backend_client_id" {
}

variable "backend_client_secret" {
}

variable "tenant_id" {
}

variable "location" {
 type = string
  default = "westeurope"
}

variable "kubernetes_version" {
  default = "1.19.6"
}

variable "backend_ssh_key" {  
}

variable resource_group_name {

}

variable "prefix" {
  default = "leo"
}

variable "display_name_prefix" {
  default = "leo-pharma"
}

variable "environment" {
}

#################### from k8s

variable "db_name" {

}