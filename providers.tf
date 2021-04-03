provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.backend_client_id
  client_secret   = var.backend_client_secret
  tenant_id       = var.tenant_id

  features {}
}

#Authenticate terraform to kubernetes
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks-leo-cluster.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks-leo-cluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks-leo-cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks-leo-cluster.kube_config.0.cluster_ca_certificate)

}