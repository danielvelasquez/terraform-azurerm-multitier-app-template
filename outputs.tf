output "kube_config" {
  value       = azurerm_kubernetes_cluster.aks-leo-cluster.kube_config_raw
  description = "Configuration of the provisioned kubernetes cluster"
}

output "cluster_ca_certificate" {
  value       = azurerm_kubernetes_cluster.aks-leo-cluster.kube_config.0.cluster_ca_certificate
  description = "ca certificate for kubernetes cluster"
}

output "client_certificate" {
  value       = azurerm_kubernetes_cluster.aks-leo-cluster.kube_config.0.client_certificate
  description = "Cluster client certificate"
}

output "client_key" {
  value       = azurerm_kubernetes_cluster.aks-leo-cluster.kube_config.0.client_key
  description = "Cluster client key"
}

output "host" {
  value       = azurerm_kubernetes_cluster.aks-leo-cluster.kube_config.0.host
  description = "TCluster host"
}

output "resource_group_name" {
  value       = azurerm_resource_group.aks-rg.name
  description = "Resource group for cluster and associated components"
}