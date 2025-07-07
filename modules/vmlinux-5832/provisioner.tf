resource "null_resource" "display_hostnames" {
  for_each = toset(local.vm_names)

  connection {
    type     = "ssh"
    user     = "azureuser"
    password = "Password1234!"
    host     = azurerm_public_ip.pip[each.key].ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "hostname"
    ]
  }

  depends_on = [azurerm_linux_virtual_machine.vm]
}

