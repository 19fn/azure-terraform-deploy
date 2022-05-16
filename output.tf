output "resource_group_name" {
  value = var.resource_group_name
}

output "storage_account_name" {
  value = var.storage_name
}

output "storage_account_container_name" {
  value = var.storage_container_name
}

output "public_ip_address" {
  value = [azurerm_linux_virtual_machine.vm.public_ip_address]
}

output "tls_private_key" {
  value     = tls_private_key.key_ssh.private_key_pem
  sensitive = true
}
