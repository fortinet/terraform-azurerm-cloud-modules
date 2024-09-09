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
| [azurerm_lb_outbound_rule.out_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_outbound_rule) | resource |
| [azurerm_lb_probe.probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.in_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.data_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_avzones"></a> [avzones](#input\_avzones) | Availability zones for load balancer's Fronted IP configurations. | `list(string)` | `[]` | no |
| <a name="input_backend_pool_name"></a> [backend\_pool\_name](#input\_backend\_pool\_name) | The name of the backend pool to be created. | `string` | `"fortigate_backend"` | no |
| <a name="input_frontend_ips"></a> [frontend\_ips](#input\_frontend\_ips) | Options for frontend\_ips:<br>  - create\_public\_ip         - (Optional\|bool) Set to `true` to create a Public IP. Default is `true`<br>  - public\_ip\_name           - (Optional\|string) The public IP name to be created. Default value is `null`.<br>  - public\_ip\_resource\_group - (Optional\|string) when using an existing Public IP created in a different Resource Group than the currently used use this property is to provide the name of that RG. Default value is `null`.<br>  - private\_ip\_address       - (Optional\|string) Specify a static IP address that will be used by a listener Default value is `null`.<br>  - vnet\_key                 - (Optional\|string) when `private_ip_address is set specifies a vnet_key, as defined in vnet variable. This will be the VNET hosting this Load Balancer. The default value is `null`.<br>  - subnet_key               - (Optional|string) when `private\_ip\_address is set specifies a subnet's key (as defined in `vnet variable) to which the LB will be attached, in case of FortiGate could be a internal/trust subnet. The default value is `null`.<br>  - inbound_rules                 - (Optional|map) Same as inbound rules for the Load Balancer.<br>  - outbound_rules                - (Optional|map) Same as outbound rules for the Load Balancer.<br>  For more information about the inbound and outbound rules, please visit https://registry.terraform.io/providers/hashicorp/azurerm/3.116.0/docs/resources/lb_rule<br><br>    Options for inbound_rules:<br>      - protocol                  - (Required|string) Protocol used for communication, possible values are 'Tcp', 'Udp' or 'All'.<br>      - port                      - (Required|string) Communication port, this is both the front and the backend port.<br>      - backend_port              - (Optional|string) The backend port to forward traffic to the backend pool.<br>      - enable_floating_ip        - (Optional|string) Enables floating IP for the rule. A "floating” IP is reassigned to a secondary server in case the primary server fails. The default value is `true`.<br>      - load_distribution         - (Optional|string) Specifies the load balancing distribution type to be used by the Load Balancer. Possible values are: `Default`. The load balancer is configured to use a 5 tuple hash to map traffic to available servers.<br><br>    Options for outbound_rules:<br>      - protocol                  - (Optional|string) Protocol used for communication, possible values are 'Tcp', 'Udp' or 'All'. Possible values are `All`, `Tcp` and `Udp`.<br>      - allocated_outbound_ports  - (Optional|string) Number of ports allocated per instance. The default is `1024`.<br>      - enable_tcp_reset          - (Optional|boolean) Is TCP Reset enabled for this Load Balancer Rule? The default is `False`.<br>      - idle_timeout_in_minutes   - (Optional|boolean) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 30 minutes.<br><br>    For more information, please visit https://registry.terraform.io/providers/hashicorp/azurerm/3.62.0/docs/resources/lb_rule<br><br>Example<br>`<pre>frontend_ips = {<br>  webserver = {<br>    create_public_ip = true<br>    gwlb_key         = "gwlb"<br>    inbound_rules = {<br>      http = {<br>      enable_floating_ip = false<br>      port               = 80<br>      protocol           = "Tcp"<br>      }<br>      https = {<br>        enable_floating_ip = false<br>        port               = 443<br>        protocol           = "Tcp"<br>      }<br>    }<br>    outbound_rules = {<br>      outbound_tcp_rule = {<br>        protocol                 = "Tcp"<br>        allocated_outbound_ports = 1024<br>        idle_timeout_in_minutes  = 5<br>        port                     = "*"<br>      }<br>    }<br>  }<br>}</pre> | `map(any)` | n/a | yes |
| <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name) | The name of the load balancer. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location for deploying the load balancer and its dependent resources | `string` | n/a | yes |
| <a name="input_network_security_group_name"></a> [network\_security\_group\_name](#input\_network\_security\_group\_name) | The name of the Network Security Group for attaching the rule. | `string` | `null` | no |
| <a name="input_probe_name"></a> [probe\_name](#input\_probe\_name) | The name of the load balancer probe. | `string` | `"fgt_health_probe"` | no |
| <a name="input_probe_port"></a> [probe\_port](#input\_probe\_port) | Health check port number of the load balancer probe. | `string` | `"80"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group where the related resources will be placed. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the resources created. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_pool_id"></a> [backend\_pool\_id](#output\_backend\_pool\_id) | The identifier of the load balancer's backend pool. |
| <a name="output_frontend_ip_configs"></a> [frontend\_ip\_configs](#output\_frontend\_ip\_configs) | Used to attach the newly-created public IP address to the load balancer. This configuration makes the load balancer available publicly. |
| <a name="output_load_balancer_id"></a> [load\_balancer\_id](#output\_load\_balancer\_id) | The identifier of the load balancer. |
