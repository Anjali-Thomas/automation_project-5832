module "rgroup" {
  source   = "./modules/rgroup-5832"
  name     = "5832-RG"
  location = "East US"
}

module "network" {
  source      = "./modules/network-5832"
  rg_name     = module.rgroup.rg_name
  vnet_name   = "5832-VNET"
  subnet_name = "5832-SUBNET"
  location    = "East US"
}

module "common" {
  source   = "./modules/common-5832"
  rg_name  = module.rgroup.rg_name
  location = "East US"
}

module "vmlinux" {
  source                      = "./modules/vmlinux-5832"
  rg_name                     = module.rgroup.rg_name
  subnet_id                   = module.network.subnet_id
  storage_account             = module.common.storage_account
  location                    = "East US"
  log_analytics_workspace_id  = module.common.log_analytics_workspace_id
  log_analytics_primary_key   = module.common.log_analytics_primary_key
}

module "vmwindows" {
  source          = "./modules/vmwindows-5832"
  rg_name         = module.rgroup.rg_name
  subnet_id       = module.network.subnet_id
  storage_account = module.common.storage_account
  location        = "East US"
}

module "datadisk" {
  source   = "./modules/datadisk-5832"
  rg_name  = module.rgroup.rg_name
  vm_ids   = concat(module.vmlinux.vm_ids, [module.vmwindows.vm_id])
  location = "East US"
}

module "loadbalancer" {
  source   = "./modules/loadbalancer-5832"
  rg_name  = module.rgroup.rg_name
  vm_nics  = module.vmlinux.nic_ids
  location = "East US"
}

module "database" {
  source   = "./modules/database-5832"
  rg_name  = module.rgroup.rg_name
  location = "East US"
}

