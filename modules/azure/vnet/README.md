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
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.nsg_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsg_asso](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_subnet.data_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.data_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The address space for the virtual network. Multiple address spaces are supported. | `list(string)` | n/a | yes |
| <a name="input_create_subnets"></a> [create\_subnets](#input\_create\_subnets) | If set to true, create new subnets within the Vnet; otherwise, use an existing subnets. | `bool` | `true` | no |
| <a name="input_create_virtual_network"></a> [create\_virtual\_network](#input\_create\_virtual\_network) | If set to true, create a new Virtual Network; otherwise, use an existing network. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | The location where the resources will be deployed. | `string` | n/a | yes |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | Manages a network security group that contains a list of network security rules. Network security groups enable inbound or outbound traffic to be enabled or denied.<br>Options:<br>- name      (Required\|string) The name of the Network Security Group.<br>- location  (Optional) Specifies the Azure location where to deploy the resource.<br>- rules     (Optional) A list of objects representing a Network Security Rule.<br><br>  Options for rules:<br>    - priority                     (Optional\|number) Numeric priority of the rule. The value can be between 100 and 4096 and must be unique for each rule.<br>    - direction                    (Optional\|string) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are `Inbound and `Outbound`.<br>    - access                       (Optional|string) Specifies whether network traffic is allowed or denied. Possible values are `Allow and `Deny`.<br>    - protocol                     (Optional\|string) Network protocol this rule applies to. Possible values include `Tcp`, `Udp`, `Icmp`, or `* (which matches all).<br>    - source_port_range            (Optional|string) A source port or a range of ports. This can also be an `* to match all.<br>    - source\_port\_ranges           (Optional\|list) A list of source ports or ranges of ports. This can be specified only if `source_port_range was not used.<br>    - destination_port_range       (Optional|string) A destination port or a range of ports. This can also be an `* to match all.<br>    - destination\_port\_ranges      (Optional\|list) A list of destination ports or a ranges of ports. This can be specified only if `destination_port_range was not used.<br>    - source_address_prefix        (Optional|string) Source CIDR or IP range or `* to match any IP.<br>    - source\_address\_prefixes      (Optional\|list) A list of source address prefixes. Can be specified only if `source_address_prefix was not used.<br>    - destination_address_prefix   (Optional|string) Destination CIDR or IP range or `* to match any IP.<br>    - destination\_address\_prefixes (Optional\|list) A list of destination address prefixes. Can be specified only if `destination_address_prefix was not used.<br><br>Example:<br>`<pre>{<br>  "allow_all_inbound" = {<br>    name = "all_inbound_nsg"<br>    location = "centralus"<br>    rules = {<br>      "Inbound" = {<br>        priority                   = 100<br>        direction                  = "Inbound"<br>        access                     = "Allow"<br>        protocol                   = "Tcp"<br>        source_port_range          = "*"<br>        source_address_prefix      = "*"<br>        destination_port_range     = "*"<br>        destination_address_prefix = "*"<br>      }<br>    }<br>  }<br>}</pre> | `any` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group where the related resources will be placed. | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to be created within a Vnet.<br>Options:<br>- name                            (Required\|string) The name of a subnet.<br>- address\_prefixes                (Required\|string) The address prefix to use for the subnet. Only required when a subnet will be created.<br>- network\_security\_group          (Required\|string) The Network Security Group identifier to associate with the subnet.<br>- enable\_storage\_service\_endpoint (Optional\|boolean) A flag that enables the Microsoft.Storage service endpoint on a subnet. This is recommended for management interfaces when full bootstrapping with an Azure Storage Account is used. The default value is false.<br><br>Example:<pre>{<br>  "public" = {<br>    name                   = "public-subnet"<br>    address_prefixes       = ["192.168.1.0/25"]<br>    network_security_group = "public_network_security_group"<br>    route_table            = "public_route_table"<br>  },<br>  "private" = {<br>    name                   = "private-subnet"<br>    address_prefixes       = ["192.168.1.128/25"]<br>    network_security_group = "private_network_security_group"<br>    route_table            = "private_route_table"<br>  }<br>}</pre> | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the resources created. | `map(any)` | `{}` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name of the Azure Virtual Network. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Identifiers for the subnets in the virtual network. |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | Identifier of the virtual network. |
