variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "provider_vnet_name" {
  description = "The name of the provider virtual network"
  type        = string
}

variable "spoke_vnet_name" {
  description = "The name of the spoke virtual network"
  type        = string
}

variable "allow_virtual_network_access" {
  description = "Allow virtual network access"
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic" {
  description = "Allow forwarded traffic"
  type        = bool
  default     = true
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "subnet_routes" {
  description = "A map of subnets with their respective route tables and routes"
  type        = map(any)
}
