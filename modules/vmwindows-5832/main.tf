resource "azurerm_availability_set" "win_avset" {
  name                         = "windows-avset"
  location                     = var.location
  resource_group_name          = var.rg_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_public_ip" "pip" {
  count               = 1
  name                = "winvm-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = lower("winvm${substr(var.rg_name, 0, 4)}")
  # domain_name_label   = "winvm-${var.rg_name}"
}

resource "azurerm_network_interface" "nic" {
  count               = 1
  name                = "winvm-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  count                 = 1
  name                  = "winvm"
  location              = var.location
  resource_group_name   = var.rg_name
  size                  = "Standard_B1ms"
  admin_username        = "azureuser"
  admin_password        = "Password1234!"
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  availability_set_id   = azurerm_availability_set.win_avset.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = "https://${var.storage_account}.blob.core.windows.net"
  }
}

resource "azurerm_virtual_machine_extension" "antimalware" {
  name                 = "IaaSAntimalware"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[0].id
  publisher            = "Microsoft.Azure.Security"
  type                 = "IaaSAntimalware"
  type_handler_version = "1.5"
  settings             = "{}"

}


resource "azurerm_virtual_machine_extension" "winrm" {
  name                       = "enable-winrm"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm[0].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
  {
    "commandToExecute": "powershell -Command \"Enable-PSRemoting -Force; Set-Item -Path WSMan:\\\\localhost\\Service\\AllowUnencrypted -Value true; Set-Item -Path WSMan:\\\\localhost\\Service\\Auth\\Basic -Value true; Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -Enabled True\""
  }
SETTINGS
}

