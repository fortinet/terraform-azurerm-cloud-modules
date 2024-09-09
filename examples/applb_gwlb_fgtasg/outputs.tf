output "vnet" {
  value = module.vnet
}

output "fortigate_instances" {
  description = "The fortigate instances in the vmss."
  value = {
    for k, v in module.fortigate_scaleset : k => v
  }
  sensitive = true
}

output "gwlb_frontend_ip_configuration_id" {
  description = "The Frontend IP Configuration ID of the Gateway SKU Load Balancer."
  value       = { for k, v in module.gwlb : k => v.frontend_ip_config_id }
}

output "standard_lb_frontend_ip" {
  description = "The IP addresses of the Standard Load Balancer."
  value       = { for k, v in module.standard_load_balancer : k => v.frontend_ip_configs }
}

output "standard_lb_id" {
  description = "Standard Load Balancer ID."
  value       = { for k, v in module.standard_load_balancer : k => v.load_balancer_id }
}

output "standard_lb_backend_pool_id" {
  description = "The backend ID of the Standard Load Balancer that servers connected with."
  value       = { for k, v in module.standard_load_balancer : k => v.backend_pool_id }
}
