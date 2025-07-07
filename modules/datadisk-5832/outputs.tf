output "datadisk_ids" {
  value = azurerm_managed_disk.disk[*].id
}

