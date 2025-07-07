terraform {
  backend "azurerm" {
    resource_group_name  = "backend-storage-rg"
    storage_account_name = "tfstateanjli5832"
    container_name       = "tfstate"
    key                  = "assignment1.terraform.tfstate"
  }
}

