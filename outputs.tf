output "linux_vm_hostnames" {
  value = module.vmlinux.hostnames
}

output "windows_vm_hostname" {
  value = module.vmwindows.hostname
}

output "load_balancer_name" {
  value = module.loadbalancer.lb_name
}

output "database_name" {
  value = module.database.db_name
}

output "storage_account_name" {
  value = module.common.storage_account
}

output "recovery_services_vault" {
  value = module.common.recovery_vault
}

output "log_analytics_workspace_id" {
  value = module.common.log_analytics_workspace_id
}

output "log_analytics_primary_key" {
  value = module.common.log_analytics_primary_key
  sensitive = true
}

output "vnet_and_subnet" {
  value = {
    vnet   = "5832-VNET"
    subnet = "5832-SUBNET"
  }
}

