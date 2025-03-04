output "fortigate_public_ip" {
  description = "The public IP address of the FortiGate VM"
  value       = { for ip in azurerm_public_ip.pip : ip.name => ip.ip_address }
}

output "network_interface_ids" {
  description = "A map of network interfaces and their resource IDs"
  value = {
    for nic in azurerm_network_interface.nic : nic.name => nic.id
  }
}
