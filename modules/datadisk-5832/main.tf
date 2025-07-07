resource "azurerm_managed_disk" "disk" {
  count                = 4
  name                 = "datadisk-${count.index + 1}"
  location             = var.location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "attach" {
  count              = 4
  managed_disk_id    = azurerm_managed_disk.disk[count.index].id
  virtual_machine_id = var.vm_ids[count.index]
  lun                = 0
  caching            = "ReadWrite"
}

