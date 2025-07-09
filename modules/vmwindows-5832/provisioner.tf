#resource "null_resource" "display_hostname" {
 #count = length(azurerm_windows_virtual_machine.vm)

 #depends_on = [azurerm_windows_virtual_machine.vm]

 #connection {
    #type     = "winrm"
    #user     = "azureuser"
    #password = "Password1234!"
    #host     = azurerm_windows_virtual_machine.vm[count.index].public_ip_address
    #port     = 5985
    #https    = false
    #timeout  = "5m"
  #}

  #provisioner "remote-exec" {
    #inline = [
      #"hostname"
    #]
  #}
#}

