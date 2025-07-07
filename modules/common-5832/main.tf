resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-${var.rg_name}"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = "vault-${var.rg_name}"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"
}

resource "azurerm_storage_account" "storage" {
  name                     = lower(replace("stor${substr(var.rg_name, 0, 10)}", "-", ""))
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

