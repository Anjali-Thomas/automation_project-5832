resource "azurerm_public_ip" "lb_pip" {
  name                = "lb-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_lb" "lb" {
  name                = "linux-lb"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  name = "backend-pool"
  #  resource_group_name = var.rg_name
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "association" {
  count                   = length(var.vm_nics)
  network_interface_id    = var.vm_nics[count.index]
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bepool.id
}

