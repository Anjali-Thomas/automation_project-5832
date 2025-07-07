output "hostnames" {
  value = [for name in local.vm_names : azurerm_linux_virtual_machine.vm[name].name]
}

output "nic_ids" {
  value = [for name in local.vm_names : azurerm_network_interface.nic[name].id]
}

output "vm_ids" {
  value = [for name in local.vm_names : azurerm_linux_virtual_machine.vm[name].id]
}

