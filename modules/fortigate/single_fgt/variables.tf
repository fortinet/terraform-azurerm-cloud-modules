variable "azure_subscription_id" {
  description = "The subscription ID associated with your Azure account. For more information, please visit [this Microsoft documentation](https://learn.microsoft.com/en-us/azure/azure-portal/get-subscription-tenant-id)."
  type        = string
}

variable "prefix" {
  description = "prefix added to the top level resources."
  type        = string
  default     = ""
}

# Resource Group name and location
variable "resource_group_creation_flag" {
  description = "Set to true to create a new resource group; set to false to use the existing resource group."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "The name of the existing Azure Resource Group."
  type        = string
  default     = ""
}

variable "virtual_network_creation_flag" {
  description = "Set to true to create a new virtual network; set to false to use the existing virtual network."
  type        = bool
  default     = true
}

variable "virtual_network_name" {
  description = "The name of the existing virtual network that the FortiGate VM will be allocated in."
  type        = string
  default     = ""
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "subnet_creation_flag" {
  description = "Set to true to create a subnet; set to false to use the existing subnet."
  type        = bool
  default     = true
}

variable "subnet_name" {
  description = "The name of the existing subnet for the FortiGate VM"
  type        = string
  default     = ""
}

variable "subnet_address_prefixes" {
  description = "The address prefix for the subnet"
  type        = list(string)
}

variable "network_interfaces" {
  description = "List of network interfaces for the FortiGate VM."
  type = list(object({
    name                    = string
    public_IP_creation_flag = optional(bool, false)
  }))
}

# FortiGate VM configuration
variable "vm_size" {
  description = "The size of the FortiGate VM"
  type        = string
  default     = "Standard_F4s"
}

variable "vm_name" {
  description = "The name of the FortiGate VM"
  type        = string
  default     = "fortigate-vm"
}

variable "admin_username" {
  description = "The admin username for the FortiGate VM"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the FortiGate VM"
  type        = string
  sensitive   = true
}

# FortiGate image info
variable "image_publisher" {
  description = "The publisher of the FortiGate image"
  type        = string
  default     = "fortinet"
}

variable "image_offer" {
  description = "The offer name of the FortiGate image"
  type        = string
  default     = "fortinet_fortigate-vm_v5"
}

variable "image_sku" {
  description = "The SKU of the FortiGate image"
  type        = string
}

variable "image_version" {
  description = "The version of the FortiGate image"
  type        = string
}

variable "storage_account_type" {
  description = "The Type of Storage Account which should back this Data Disk. Possible values include Standard_LRS, StandardSSD_LRS, StandardSSD_ZRS, Premium_LRS, PremiumV2_LRS, Premium_ZRS and UltraSSD_LRS."
  type        = string
  default     = "StandardSSD_LRS"
}

variable "disk_encryption_set_id" {
  description = "The ID of the Disk Encryption Set which should be used to encrypt this Data Disk."
  type        = string
  default     = null
}

# Network Security Group rules
variable "allowed_ports" {
  description = "List of allowed inbound ports for the FortiGate VM"
  type        = list(number)
  default     = [80, 443]
}

variable "tags" {
  description = "Tags for the created resources."
  type        = map(string)
  default     = {}
}

variable "fgt_user_data_template" {
  description = "stores the template to config licenses and other custom data"
  type        = string
  default     = "./fgt_user_data.tpl"
}

variable "fgt_custom_data_file_path" {
  description = "custom configurations for the fortigate"
  type        = string
  default     = ""
}

variable "fgt_license_file_path" {
  description = "path to the license file if user selects to use the byol license type"
  type        = string
  default     = ""
}

variable "fgt_license_fortiflex" {
  description = "the fortiflex token to use if user selects to use the flex token"
  type        = string
  default     = ""
}
