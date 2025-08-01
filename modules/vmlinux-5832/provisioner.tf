resource "null_resource" "ansible_provisioner" {
  for_each = azurerm_linux_virtual_machine.vm

  connection {
    type        = "ssh"
    host        = each.value.public_ip_address
    user        = "azureuser"
    password = "Password1234!"    
#private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "sudo dnf -y update",
      "sudo dnf -y install python3"
      #"sudo apt-get update -y",
      #"sudo apt-get install -y ansible"
    ]
  }
provisioner "local-exec" {
  command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${each.value.public_ip_address},' -u azureuser --extra-vars 'ansible_password=Password1234!' ansible/5832-playbook.yml --ssh-extra-args='-o StrictHostKeyChecking=no'"
}
}
