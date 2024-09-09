output "virtual_network_id" {
  description = "Identifier of the virtual network."
  value       = local.virtual_network.id
}

output "subnet_ids" {
  description = "Identifiers for the subnets in the virtual network."
  value       = { for k, v in local.subnets : k => v.id }
}
