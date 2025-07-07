output "hostname" {
  value = azurerm_windows_virtual_machine.vm[0].name
}

output "vm_id" {
  value = azurerm_windows_virtual_machine.vm[0].id
}

