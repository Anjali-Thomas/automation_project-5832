resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = lower(replace("pgflex${substr(var.rg_name, 0, 12)}", "-", ""))
  location               = var.location
  resource_group_name    = var.rg_name
  administrator_login    = "pgadmin"
  administrator_password = "Password1234!"
  version                = "13"

  sku_name               = "B_Standard_B1ms"

  storage_mb                     = 32768
  backup_retention_days          = 7
  geo_redundant_backup_enabled   = false
  zone                           = "1"
  auto_grow_enabled              = true
  public_network_access_enabled  = true

  maintenance_window {
    day_of_week  = 0
    start_hour   = 0
    start_minute = 0
  }

  tags = {
    Assignment     = "CCGC 5502 Automation Assignment"
    Name           = "firstname.lastname"
    ExpirationDate = "2024-12-31"
    Environment    = "Learning"
  }
}


