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
  description = "The name of the existing virtual network that the VM will be allocated in."
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
  description = "The name of the existing subnet for the VM"
  type        = string
  default     = ""
}

variable "subnet_address_prefixes" {
  description = "The address prefix for the subnet"
  type        = list(string)
}

variable "network_interfaces" {
  description = "List of network interfaces for the VM."
  type = list(object({
    name                    = string
    public_IP_creation_flag = optional(bool, false)
  }))
}

# VM configuration
variable "vm_size" {
  description = "The size of the instance"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the VM. Set this explicitly for each deployment."
  type        = string
  validation {
    condition     = trimspace(var.admin_username) != ""
    error_message = "The admin_username must be provided and cannot be empty."
  }
}

variable "admin_password" {
  description = "The admin password for the VM. Set this explicitly using a secure input method such as terraform.tfvars, TF_VAR_admin_password, or your CI/CD secret store."
  type        = string
  sensitive   = true
  validation {
    condition = (
      trimspace(var.admin_password) != "" &&
      length(var.admin_password) >= 12 &&
      can(regex("[A-Z]", var.admin_password)) &&
      can(regex("[a-z]", var.admin_password)) &&
      can(regex("[0-9]", var.admin_password)) &&
      can(regex("[^A-Za-z0-9]", var.admin_password)) &&
      !contains([
        "Fortinet@123",
        "Fortinet@123456",
        "Fortinet@123456!",
        "Fortinet###",
        "Password123!",
        "ChangeMe123!"
      ], var.admin_password)
    )
    error_message = "The admin_password must be provided, must be at least 12 characters, must include uppercase, lowercase, numeric, and special characters, and must not use a known default password."
  }
}

# Image info
variable "image_publisher" {
  description = "The publisher of the image"
  type        = string
  default     = "fortinet"
}

variable "image_offer" {
  description = "The offer name of the image"
  type        = string
  default     = ""
}

variable "sku" {
  description = "Fortinet image SKU to use directly. If provided, this will be used instead of the SKU computed from product_name, license_type, image_version, gen_type, and architecture. Azure still requires image_version separately. The Gen1 FortiGate SKUs fortinet_fg-vm_byol_76, fortinet_fg-vm_payg_76, fortinet_fg-vm_byol_80, and fortinet_fg-vm_payg_80 are not allowed."
  type        = string
  default     = null
  validation {
    condition = var.sku == null ? true : !contains([
      "fortinet_fg-vm_byol_76",
      "fortinet_fg-vm_payg_76",
      "fortinet_fg-vm_byol_80",
      "fortinet_fg-vm_payg_80"
    ], lower(var.sku))
    error_message = "The FortiGate Gen1 SKUs fortinet_fg-vm_byol_76, fortinet_fg-vm_payg_76, fortinet_fg-vm_byol_80, and fortinet_fg-vm_payg_80 are not supported. Use the corresponding _g2 SKU for FortiGate 7.6 or 8.0."
  }
}

variable "image_version" {
  description = "The version of the image"
  type        = string
}

variable "license_type" {
  description = "FortiGate license type used to format image SKU. Allowed values: byol, payg."
  type        = string
  default     = "byol"
  validation {
    condition     = contains(["byol", "payg"], lower(var.license_type))
    error_message = "The license_type must be either byol or payg."
  }
}

variable "gen_type" {
  description = "FortiGate generation type used to format image SKU. Allowed values: standard, g2."
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "g2"], lower(var.gen_type))
    error_message = "The gen_type must be either standard or g2."
  }
}

variable "architecture" {
  description = "FortiGate CPU architecture used to format image SKU. Allowed values: x64, arm64."
  type        = string
  default     = "x64"
  validation {
    condition     = contains(["x64", "arm64"], lower(var.architecture))
    error_message = "The architecture must be either x64 or arm64."
  }
}

variable "product_name" {
  description = "The short name for a Fortinet product. Allowed values: fortiproxy, fortigate, fortimanager, fortianalyzer, fortiguest, fortiaiops, fortigate-arm64, fortigate-g2, fortigate-payg, fortigate-payg-g2, fortigate-payg-arm64."
  type        = string
  validation {
    condition = contains([
      "fortiproxy",
      "fortigate",
      "fortimanager",
      "fortianalyzer",
      "fortiguest",
      "fortiaiops",
      "fortigate-arm64",
      "fortigate-g2",
      "fortigate-payg",
      "fortigate-payg-g2",
      "fortigate-payg-arm64"
    ], var.product_name)
    error_message = "The product_name must be one of the following: fortiproxy, fortigate, fortimanager, fortianalyzer, fortiguest, fortiaiops, fortigate-arm64, fortigate-g2, fortigate-payg, fortigate-payg-g2, fortigate-payg-arm64."
  }
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
variable "nsg_rules" {
  description = "List of NSG rules for the VM."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

variable "tags" {
  description = "Tags for the created resources."
  type        = map(string)
  default     = {}
}

variable "bootstrap_template" {
  description = "stores the template to config licenses and other custom data"
  type        = string
  default     = "./fgt_bootstrap.tpl"
}

variable "custom_data_file_path" {
  description = "custom configurations for the fortigate/fortimanager/fortianalyzer"
  type        = string
  default     = ""
}

variable "license_file_path" {
  description = "path to the license file if user selects to use the byol license type"
  type        = string
  default     = ""
}

variable "license_fortiflex" {
  description = "the fortiflex token to use if user selects to use the flex token"
  type        = string
  default     = ""
}
