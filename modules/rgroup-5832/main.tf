resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location

  tags = {
    Assignment     = "CCGC 5502 Automation Assignment"
    Name           = "anjali.thomas"
    ExpirationDate = "2024-12-31"
    Environment    = "Learning"
  }
}

