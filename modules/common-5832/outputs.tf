output "log_analytics_name" {
  value = azurerm_log_analytics_workspace.log.name
}

#output "log_analytics_workspace_id" {
 # value = azurerm_log_analytics_workspace.log.id
#}

#output "log_analytics_primary_key" {
 # value = azurerm_log_analytics_workspace.log.primary_shared_key
 # sensitive = true
#}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log.workspace_id
}

output "log_analytics_primary_key" {
  value     = azurerm_log_analytics_workspace.log.primary_shared_key
  sensitive = true
}

output "recovery_vault" {
  value = azurerm_recovery_services_vault.vault.name
}

output "storage_account" {
  value = azurerm_storage_account.storage.name
}
