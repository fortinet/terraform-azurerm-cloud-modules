output "backend_pool_ids" {
  description = "GWLB backend pools' identifier."
  value       = { for k, v in azurerm_lb_backend_address_pool.lb_backend : k => v.id }
}

output "frontend_ip_config_id" {
  description = "GWLB frontend IP configuration identifier."
  value       = azurerm_lb.lb.frontend_ip_configuration[0].id
}

output "private_ip_address" {
  description = "The private IP address for the GWlb"
  value       = azurerm_lb.lb.private_ip_address
}
