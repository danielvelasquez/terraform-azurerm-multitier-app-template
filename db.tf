resource "azurerm_cosmosdb_account" "db" {
  name                = var.db_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = false

  consistency_policy {
    consistency_level       = "Session"
   
  }
  capabilities {
    name = "EnableMongo"
 }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "mongo-db" {
  name                = "leo-cosmos-mongo-db"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.db.name
  throughput          = 400
}

resource "kubernetes_secret" "db_secret" {
  metadata {
    name      = "db-secret"
    namespace = var.environment
  }
  data = {
    "appinsights" = azurerm_application_insights.app-insights.instrumentation_key 
    "pwd"         = azurerm_cosmosdb_account.db.primary_key
    "user"        = azurerm_cosmosdb_account.db.name
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks-leo-cluster,
  ]
}