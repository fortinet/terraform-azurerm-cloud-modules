## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_lb.lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.lb_backend](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_probe.lb_probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.lb_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_pools"></a> [backend\_pools](#input\_backend\_pools) | Manages a Load Balancer Backend Address Pool.<br/>Options:<br/>- name              - (Optional\|string) The name of the backend pool.<br/>- tunnel\_interfaces - (Required\|map) Tunnel interfaces blocks.<br/><br/>  Options for tunnel\_interfaces:<br/>  - identifier - (Required\|int)  The unique identifier of this Gateway Load Balancer Tunnel Interface.<br/>  - port       - (Required\|int) The port number that this Gateway Load Balancer Tunnel Interface listens to.<br/>  - type       - (Required\|string) The traffic type of this Gateway Load Balancer Tunnel Interface. Possible values are `Internal` and `External`.<pre>Example:<br/><br/>backend_pools = {<br/>  internal_external = {<br/>    tunnel_interfaces = {<br/>      internal = {<br/>        identifier = 800<br/>        port       = 2000<br/>        type       = "Internal"<br/>      }<br/>      external = {<br/>        identifier = 801<br/>        port       = 2001<br/>        type       = "External"<br/>      }<br/>    }<br/>  }<br/>}</pre> | `map(any)` | n/a | yes |
| <a name="input_frontend_ip_config"></a> [frontend\_ip\_config](#input\_frontend\_ip\_config) | Frontend IP configurations of the Gateway Load Balancer.<br/>Options:<br/>- name                          - (Optional\|string) The name of the frontend IP configuration.<br/>- private\_ip\_address\_allocation - (Optional\|string) The allocation method for the Private IP Address used by this Load Balancer. Possible values as `Dynamic` and `Static`.<br/>- private\_ip\_address\_version    - (Optional\|string) The version of IP that the Private IP Address is. Possible values are `IPv4` or `IPv6`.<br/>- private\_ip\_address            - (Optional\|string) Private IP Address to assign to the Load Balancer.<br/>- subnet\_id                     - (Required\|string) The ID of the Subnet which is associated with the IP Configuration<br/>- zones                         - (Optional\|list) Specifies a list of Availability Zones in which the IP Address for this Load Balancer should be located. | <pre>object({<br/>    name                          = optional(string)<br/>    private_ip_address_allocation = optional(string, "Dynamic")<br/>    private_ip_address_version    = optional(string, "IPv4")<br/>    private_ip_address            = optional(string)<br/>    subnet_id                     = string<br/>    zones                         = optional(list(string), [])<br/>  })</pre> | n/a | yes |
| <a name="input_gwlb_name"></a> [gwlb\_name](#input\_gwlb\_name) | The name of the gateway load balancer. | `string` | n/a | yes |
| <a name="input_health_probe"></a> [health\_probe](#input\_health\_probe) | Health probe configuration for the gateway load balancer backend\_pools.<br/>Options:<br/>- name                - (Optional\|string) The name of the health probe.<br/>- protocol            - (Optional\|string) Specifies the protocol of the end point. Possible values are Http, Https or Tcp.<br/>- port                - (Required\|int) Port on which the Probe queries the backend endpoint. Possible values range from 1 to 65535, inclusive.<br/>- probe\_threshold     - (Optional\|int) The number of consecutive successful or failed probes that allow or deny traffic to this endpoint. Possible values range from 1 to 100.<br/>- request\_path        - (Optional\|string) The URI used for requesting health status from the backend endpoint. Required if protocol is set to Http or Https. Otherwise, it is not allowed.<br/>- interval\_in\_seconds - (Optional\|int) The interval, in seconds between probes to the backend endpoint for health status.<br/>- number\_of\_probes    - (Optional\|int) The number of failed probe attempts after which the backend endpoint is removed from rotation. | `map(any)` | n/a | yes |
| <a name="input_lb_rule"></a> [lb\_rule](#input\_lb\_rule) | Manages a Load Balancer Rule.<br/>Options:<br/>- name              - (Optional\|string) Specifies the name of the LB Rule.<br/>- load\_distribution - (Optional\|string) Specifies the load balancing distribution type to be used by the Load Balancer. Possible values refers to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule | `map(string)` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location for deploying the load balancer and its dependent resources | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group where the related resources will be placed. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the created resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_pool_ids"></a> [backend\_pool\_ids](#output\_backend\_pool\_ids) | GWLB backend pools' identifier. |
| <a name="output_frontend_ip_config_id"></a> [frontend\_ip\_config\_id](#output\_frontend\_ip\_config\_id) | GWLB frontend IP configuration identifier. |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The private IP address for the GWlb |
