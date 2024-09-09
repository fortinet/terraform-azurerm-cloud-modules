output "frontend_ip_configs" {
  description = "Used to attach the newly-created public IP address to the load balancer. This configuration makes the load balancer available publicly."
  value       = local.frontend_addresses
}

output "load_balancer_id" {
  description = "The identifier of the load balancer."
  value       = azurerm_lb.lb.id
}

output "backend_pool_id" {
  description = "The identifier of the load balancer's backend pool."
  value       = azurerm_lb_backend_address_pool.lb_backend.id
}
