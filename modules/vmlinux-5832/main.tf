resource "azurerm_availability_set" "linux_avset" {
  name                         = "linux-avset"
  location                     = var.location
  resource_group_name          = var.rg_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

locals {
  vm_names = ["linuxvm1", "linuxvm2", "linuxvm3"]
}

resource "azurerm_public_ip" "pip" {
  for_each            = toset(local.vm_names)
  name                = "${each.value}-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  domain_name_label   = lower("${each.value}${substr(var.rg_name, 0, 4)}")

#  lifecycle {
 #     prevent_destroy = true
 # }
  
  tags = {
    Assignment     = "CCGC 5502 Automation Assignment"
    Name           = "firstname.lastname"
    ExpirationDate = "2024-12-31"
    Environment    = "Learning"
  }
}

resource "azurerm_network_interface" "nic" {
  for_each            = toset(local.vm_names)
  name                = "${each.value}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
    lifecycle {
    ignore_changes = [
      ip_configuration[0].public_ip_address_id
    ]
  }
}
resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = toset(local.vm_names)
  name                            = each.value
  location                        = var.location
  resource_group_name             = var.rg_name
  size                            = "Standard_B1ms"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  availability_set_id   = azurerm_availability_set.linux_avset.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = "https://${var.storage_account}.blob.core.windows.net"
  }

  tags = {
    Assignment     = "CCGC 5502 Automation Assignment"
    Name           = "firstname.lastname"
    ExpirationDate = "2024-12-31"
    Environment    = "Learning"
  }
}

resource "azurerm_virtual_machine_extension" "watcher" {
  for_each                   = toset(local.vm_names)
  name                       = "${each.key}-watcher"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentLinux"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "monitor" {
  for_each                   = toset(local.vm_names)
  name                       = "${each.key}-monitor"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OmsAgentForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    workspaceId = var.log_analytics_workspace_id
  })

  protected_settings = jsonencode({
    workspaceKey = var.log_analytics_primary_key
  })
}
