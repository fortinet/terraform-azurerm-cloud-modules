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
| [azurerm_linux_virtual_machine.instance_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.nic_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsg_asso](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_resource_group.existing_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.existing_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.existing_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The admin password for the VM | `string` | `"Fortinet@123456"` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The admin username for the VM | `string` | `"azureadmin"` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | The subscription ID associated with your Azure account. For more information, please visit [this Microsoft documentation](https://learn.microsoft.com/en-us/azure/azure-portal/get-subscription-tenant-id). | `string` | n/a | yes |
| <a name="input_custom_data_file_path"></a> [custom\_data\_file\_path](#input\_custom\_data\_file\_path) | custom configurations for the fortigate/fortimanager/fortianalyzer | `string` | `""` | no |
| <a name="input_disk_encryption_set_id"></a> [disk\_encryption\_set\_id](#input\_disk\_encryption\_set\_id) | The ID of the Disk Encryption Set which should be used to encrypt this Data Disk. | `string` | `null` | no |
| <a name="input_image_offer"></a> [image\_offer](#input\_image\_offer) | The offer name of the image | `string` | `""` | no |
| <a name="input_image_publisher"></a> [image\_publisher](#input\_image\_publisher) | The publisher of the image | `string` | `"fortinet"` | no |
| <a name="input_image_sku"></a> [image\_sku](#input\_image\_sku) | The SKU of the image | `string` | `""` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | The version of the image | `string` | n/a | yes |
| <a name="input_license_file_path"></a> [license\_file\_path](#input\_license\_file\_path) | path to the license file if user selects to use the byol license type | `string` | `""` | no |
| <a name="input_license_fortiflex"></a> [license\_fortiflex](#input\_license\_fortiflex) | the fortiflex token to use if user selects to use the flex token | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where resources will be created | `string` | n/a | yes |
| <a name="input_network_interfaces"></a> [network\_interfaces](#input\_network\_interfaces) | List of network interfaces for the VM. | <pre>list(object({<br/>    name                    = string<br/>    public_IP_creation_flag = optional(bool, false)<br/>  }))</pre> | n/a | yes |
| <a name="input_nsg_rules"></a> [nsg\_rules](#input\_nsg\_rules) | List of NSG rules for the VM. | <pre>list(object({<br/>    name                       = string<br/>    priority                   = number<br/>    direction                  = string<br/>    access                     = string<br/>    protocol                   = string<br/>    source_port_range          = string<br/>    destination_port_range     = string<br/>    source_address_prefix      = string<br/>    destination_address_prefix = string<br/>  }))</pre> | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | prefix added to the top level resources. | `string` | `""` | no |
| <a name="input_product_name"></a> [product\_name](#input\_product\_name) | The short name for a Fortinet product. Allowed values: fortigate, fortimanager, fortianalyzer, fortiguest, fortiaiops, fortigate-arm64, fortigate-g2, fortigate-payg, fortigate-payg-g2, fortigate-payg-arm64. | `string` | n/a | yes |
| <a name="input_resource_group_creation_flag"></a> [resource\_group\_creation\_flag](#input\_resource\_group\_creation\_flag) | Set to true to create a new resource group; set to false to use the existing resource group. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the existing Azure Resource Group. | `string` | `""` | no |
| <a name="input_storage_account_type"></a> [storage\_account\_type](#input\_storage\_account\_type) | The Type of Storage Account which should back this Data Disk. Possible values include Standard\_LRS, StandardSSD\_LRS, StandardSSD\_ZRS, Premium\_LRS, PremiumV2\_LRS, Premium\_ZRS and UltraSSD\_LRS. | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#input\_subnet\_address\_prefixes) | The address prefix for the subnet | `list(string)` | n/a | yes |
| <a name="input_subnet_creation_flag"></a> [subnet\_creation\_flag](#input\_subnet\_creation\_flag) | Set to true to create a subnet; set to false to use the existing subnet. | `bool` | `true` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the existing subnet for the VM | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the created resources. | `map(string)` | `{}` | no |
| <a name="input_user_data_template"></a> [user\_data\_template](#input\_user\_data\_template) | stores the template to config licenses and other custom data | `string` | `"./user_data.tpl"` | no |
| <a name="input_virtual_network_creation_flag"></a> [virtual\_network\_creation\_flag](#input\_virtual\_network\_creation\_flag) | Set to true to create a new virtual network; set to false to use the existing virtual network. | `bool` | `true` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the existing virtual network that the VM will be allocated in. | `string` | `""` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the instance | `string` | n/a | yes |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space for the virtual network. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | The public IP address of the deployed instance |
| <a name="output_network_interface_ids"></a> [network\_interface\_ids](#output\_network\_interface\_ids) | A map of network interfaces and their resource IDs |
