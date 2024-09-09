variable "gwlb_name" {
  description = "The name of the gateway load balancer."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group where the related resources will be placed."
  type        = string
}

variable "location" {
  description = "The location for deploying the load balancer and its dependent resources"
  type        = string
}

variable "frontend_ip_config" {
  description = <<-EOF
  Frontend IP configurations of the Gateway Load Balancer.
  Options:
  - name                          - (Optional|string) The name of the frontend IP configuration.
  - private_ip_address_allocation - (Optional|string) The allocation method for the Private IP Address used by this Load Balancer. Possible values as `Dynamic` and `Static`.
  - private_ip_address_version    - (Optional|string) The version of IP that the Private IP Address is. Possible values are `IPv4` or `IPv6`.
  - private_ip_address            - (Optional|string) Private IP Address to assign to the Load Balancer.
  - subnet_id                     - (Required|string) The ID of the Subnet which is associated with the IP Configuration
  - zones                         - (Optional|list) Specifies a list of Availability Zones in which the IP Address for this Load Balancer should be located.
  EOF

  type = object({
    name                          = optional(string)
    private_ip_address_allocation = optional(string, "Dynamic")
    private_ip_address_version    = optional(string, "IPv4")
    private_ip_address            = optional(string)
    subnet_id                     = string
    zones                         = optional(list(string), [])
  })
}

variable "backend_pools" {
  description = <<-EOF
  Manages a Load Balancer Backend Address Pool.
  Options:
  - name              - (Optional|string) The name of the backend pool.
  - tunnel_interfaces - (Required|map) Tunnel interfaces blocks.

    Options for tunnel_interfaces:
    - identifier - (Required|int)  The unique identifier of this Gateway Load Balancer Tunnel Interface.
    - port       - (Required|int) The port number that this Gateway Load Balancer Tunnel Interface listens to.
    - type       - (Required|string) The traffic type of this Gateway Load Balancer Tunnel Interface. Possible values are `Internal` and `External`.

  ```
  Example:

  backend_pools = {
    internal_external = {
      tunnel_interfaces = {
        internal = {
          identifier = 800
          port       = 2000
          type       = "Internal"
        }
        external = {
          identifier = 801
          port       = 2001
          type       = "External"
        }
      }
    }
  }
  ```

  EOF

  type = map(any)
}

variable "health_probe" {
  description = <<-EOF
  Health probe configuration for the gateway load balancer backend_pools.
  Options:
  - name                - (Optional|string) The name of the health probe.
  - protocol            - (Optional|string) Specifies the protocol of the end point. Possible values are Http, Https or Tcp.
  - port                - (Required|int) Port on which the Probe queries the backend endpoint. Possible values range from 1 to 65535, inclusive.
  - probe_threshold     - (Optional|int) The number of consecutive successful or failed probes that allow or deny traffic to this endpoint. Possible values range from 1 to 100.
  - request_path        - (Optional|string) The URI used for requesting health status from the backend endpoint. Required if protocol is set to Http or Https. Otherwise, it is not allowed.
  - interval_in_seconds - (Optional|int) The interval, in seconds between probes to the backend endpoint for health status.
  - number_of_probes    - (Optional|int) The number of failed probe attempts after which the backend endpoint is removed from rotation.

  EOF
  type        = map(any)
}

variable "lb_rule" {
  description = <<-EOF
  Manages a Load Balancer Rule.
  Options:
  - name              - (Optional|string) Specifies the name of the LB Rule.
  - load_distribution - (Optional|string) Specifies the load balancing distribution type to be used by the Load Balancer. Possible values refers to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule
  EOF
  type        = map(string)
  default     = null
}

variable "tags" {
  description = "Tags for the created resources."
  type        = map(string)
  default     = {}
}
