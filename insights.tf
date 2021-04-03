resource "azurerm_application_insights" "app-insights" {
  name                = "tf-test-appinsights"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  application_type    = "web"
}