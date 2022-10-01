resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "cosmos_db" {
  name                = "${var.project_name}-cosmos-db-${random_integer.ri.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rsg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = false
  enable_free_tier = true

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  tags = var.tags

  depends_on = [
    azurerm_resource_group.rsg
  ]
}

resource "azurerm_cosmosdb_sql_database" "cosmos_db" {
  name                = var.sql_db_name
  resource_group_name = azurerm_cosmosdb_account.cosmos_db.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos_db.name
  throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "cosmos_db" {
  name                  = var.sql_db_container_name
  resource_group_name   = azurerm_resource_group.rsg.name
  account_name          = azurerm_cosmosdb_account.cosmos_db.name
  database_name         = azurerm_cosmosdb_sql_database.cosmos_db.name
  partition_key_path    = "/id"
  partition_key_version = 1

  autoscale_settings {
    max_throughput = 1000 # Para mantener el nivel gratuito
  }

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}

