output "virtual_network_id" {
  description = "Identifier of the virtual network."
  value       = local.virtual_network.id
}

output "vnet_name" {
  description = "Name of the virtual network."
  value       = local.virtual_network.name
}

output "subnet_ids" {
  description = "Identifiers for the subnets in the virtual network."
  value       = { for k, v in local.subnets : k => v.id }
}

output "subnet_address_prefixes" {
  description = "Address prefixes of the subnets in the virtual network."
  value       = { for k, v in local.subnets : k => v.address_prefixes }
}

output "address_space" {
  description = "Address space of the virtual network."
  value       = local.virtual_network.address_space
}
