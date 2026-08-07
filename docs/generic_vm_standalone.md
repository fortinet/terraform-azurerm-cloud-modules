Deploy a single Fortinet product on Azure, including FortiGate, FortiProxy, FortiManager, FortiAnalyzer, FortiGuest, or FortiAIOps, using the streamlined and efficient Terraform module `generic_vm_standalone`.

**Introduction**

This Terraform module, located at `/modules/fortinet/generic_vm_standalone`, provides a streamlined solution for deploying a single Fortinet Virtual Machine on Microsoft Azure. It supports a range of Fortinet products, including FortiGate, FortiProxy, FortiManager, FortiAnalyzer, FortiGuest, and FortiAIOps. By following the steps outlined below, you can efficiently set up and configure your desired Fortinet product in the Azure environment.

**Supported Product Names and Image Versions**
To deploy a Fortinet product, the `product_name` and `image_version` parameters are mandatory. Users must refer to the table below to select the appropriate product name and image version based on the product description and supported image versions.

| Product Name          | Supported Image Versions | Description                              | SKU for the product name                                                     |
|------------------------|--------------------|------------------------------------------|-----------------------------------------------------------------------------|
| fortimanager           | 6.2.0 - 8.0.0     | Centralized management for Fortinet devices | fortinet-fortimanager               |
| fortianalyzer          | 6.2.0 - 8.0.0     | Log management and analytics for Fortinet devices | fortinet-fortianalyzer        |
| fortiproxy             | 7.2.10 - 7.6.2   | Secure web proxy and web filtering solution | fpx-vm-byol                         |
| fortiguest             | 2.0.00205 - 2.4.20520 | Guest management solution                | fortinet_fortiguest-vm         |
| fortiaiops             | 2.0.1 - 3.2.1 | AI-powered operations for Fortinet devices | fortinet_fortiaiops-vm               |
| fortigate              | 7.0.19 - 8.0.0     | BYOL x64 next-generation firewall. For 7.6 and later, the module selects the G2 SKU. | 7.0/7.2/7.4: fortinet_fg-vm_byol_<version_train>; 7.6/8.0: fortinet_fg-vm_byol_<version_train>_g2 |
| fortigate-arm64        | 7.2.13 - 8.0.0     | BYOL ARM64-based next-generation firewall     | fortinet_fg-vm_byol_<version_train>_arm64 |
| fortigate-g2           | 7.4.11 - 8.0.0     | BYOL second-generation next-generation firewall | fortinet_fg-vm_byol_<version_train>_g2 |
| fortigate-payg         | 7.0.19 - 8.0.0     | Pay-as-you-go x64 next-generation firewall. For 7.6 and later, the module selects the G2 SKU. | 7.0/7.2/7.4: fortinet_fg-vm_payg_<version_train>; 7.6/8.0: fortinet_fg-vm_payg_<version_train>_g2 |
| fortigate-payg-g2      | 7.4.11 - 8.0.0     | Pay-as-you-go second-generation firewall | fortinet_fg-vm_payg_<version_train>_g2 |
| fortigate-payg-arm64   | 7.2.13 - 8.0.0     | Pay-as-you-go ARM64-based firewall       | fortinet_fg-vm_payg_<version_train>_arm64 |

> **Note**: Do not use the Marketplace-visible Gen1 SKUs `fortinet_fg-vm_byol_76`, `fortinet_fg-vm_payg_76`, `fortinet_fg-vm_byol_80`, or `fortinet_fg-vm_payg_80`. FortiGate 7.6 and 8.0 x64 deployments should use the corresponding `_g2` SKUs.

> **Direct SKU usage**: When setting `sku` directly, users must still provide `product_name` and `image_version`. The `sku` input only bypasses SKU computation from `license_type`, `gen_type`, and `architecture`; Azure requires the image version as a separate field.

```hcl
product_name  = "fortigate"
sku           = "fortinet_fg-vm_payg_80_g2"
image_version = "8.0.0"
```


**Deployment Steps**

1. Select a product deployment example from the options below and carefully review all the parameters provided.
2. Replace all placeholder values marked as `"YOUR_OWN_VALUE"` with the appropriate values specific to your deployment requirements. Replace password placeholders with a strong password that meets the module validation rules.
3. Execute the following commands to initialize and apply the Terraform configuration:

  ```sh
  terraform init
  terraform apply
  ```

**Example Usage of the `generic_vm_standalone` Module for Various Fortinet Products**

Below are examples of how to deploy a single FortiGuest, FortiAIOPS, FortiProxy, FortiGate, FortiManager, FortiAnalyzer using the `generic_vm_standalone` Terraform module. Replace all placeholder values marked as `"YOUR_OWN_VALUE"` with your specific deployment details. Replace password placeholders with a strong password that meets the module validation rules. Ensure you review and adjust the parameters to match your specific requirements.

> **Note**: The `admin_username` and `admin_password` inputs are required for every `generic_vm_standalone` deployment because Azure requires VM administrator credentials. For FortiGuest and FortiAIOPS, the product GUI may still use its appliance default first-login flow: username `admin` and an empty password, followed by a prompt to set a new password.

#### FortiGuest Deployment Example

```hcl
module "single_vm" {
  source = "fortinetdev/cloud-modules/azurerm/modules/fortinet/generic_vm_standalone"

  azure_subscription_id = "YOUR_OWN_VALUE"

  # prefix used for all top level resources
  prefix = "single_fortiguest_test"

  # Only needed if you'd like to use the existing resources.
  # resource_group_name  = "YOUR_OWN_VALUE"
  # virtual_network_name = "YOUR_OWN_VALUE"
  # subnet_name          = "YOUR_OWN_VALUE"

  location = "Central US"

  # Only needed if you'd like to create new vnet and subnet (not using the existing resources.) Your own values for vnet_address_space and subnet_address_prefixes. Default values will be used if not provided.
  vnet_address_space      = ["10.0.0.0/16"]
  subnet_address_prefixes = ["10.0.1.0/24"]

  # username and password required for the Azure VM
  admin_username = "YOUR_OWN_VALUE"
  admin_password = "Your_Own_Strong_Password_123!"

  # Check the product name in /docs/generic_vm_standalone.md
  product_name  = "fortiguest"
  image_version = "2.0.00205"
  vm_size       = "Standard_D4_v3"

  # network_interfaces, set public_IP_creation_flag to true will creat a piblic IP. Define more interfaces as needed.
  network_interfaces = [
    {
      name                    = "port1"
      public_IP_creation_flag = true
    }
  ]

  nsg_rules = [
    {
      name                       = "Allow-SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-HTTPS"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-UDP-1812"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "1812"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-UDP-1813"
      priority                   = 400
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "1813"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}
```

#### FortiAIOPS Deployment Example

```hcl
module "single_vm" {
  source = "fortinetdev/cloud-modules/azurerm/modules/fortinet/generic_vm_standalone"

  azure_subscription_id = "YOUR_OWN_VALUE"

  # Prefix for all top-level resources
  prefix = "single_fortiaiops_test"

  # Location for deployment
  location = "Central US"

  # Only needed if you'd like to use the existing resources.
  # resource_group_name  = "YOUR_OWN_VALUE"
  # virtual_network_name = "YOUR_OWN_VALUE"
  # subnet_name          = "YOUR_OWN_VALUE"

  # Virtual network and subnet configuration
  vnet_address_space      = ["10.0.0.0/16"]
  subnet_address_prefixes = ["10.0.1.0/24"]

  # username and password required for the Azure VM
  admin_username = "YOUR_OWN_VALUE"
  admin_password = "Your_Own_Strong_Password_123!"

  # Check the product name in /docs/generic_vm_standalone.md
  product_name  = "fortiaiops"
  image_version = "2.1.0"
  vm_size       = "Standard_E4_v4"

  # Network interfaces
  network_interfaces = [
    {
      name                    = "port1"
      public_IP_creation_flag = true
    }
  ]

  nsg_rules = [
    {
      name                       = "Allow-SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-HTTPS"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-UDP-514"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "514"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-UDP-4013"
      priority                   = 400
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "4013"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}
```

#### FortiProxy Deployment Example

```hcl
module "single_vm" {
  source = "fortinetdev/cloud-modules/azurerm/modules/fortinet/generic_vm_standalone"

  azure_subscription_id = "YOUR_OWN_VALUE"

  # prefix used for all top level resources
  prefix = "single_fortiproxy_test"

  # Only needed if you'd like to use the existing resources.
  # resource_group_name  = "YOUR_OWN_VALUE"
  # virtual_network_name = "YOUR_OWN_VALUE"
  # subnet_name          = "YOUR_OWN_VALUE"

  location = "Central US"

  # Only needed if you'd like to create new vnet and subnet (not using the existing resources.) Your own values for vnet_address_space and subnet_address_prefixes. Default values will be used if not provided.
  vnet_address_space      = ["10.0.0.0/16"]
  subnet_address_prefixes = ["10.0.1.0/24"]

  # username and password required for the Azure VM
  admin_username = "YOUR_OWN_VALUE"
  admin_password = "Your_Own_Strong_Password_123!"

  # Check the product name in /docs/generic_vm_standalone.md
  product_name  = "fortiproxy"
  image_version = "7.6.2"
  vm_size       = "Standard_D4_v3"

  # network_interfaces, set public_IP_creation_flag to true will creat a piblic IP. Define more interfaces as needed.
  network_interfaces = [
    {
      name                    = "port1"
      public_IP_creation_flag = true
    }
  ]

  nsg_rules = [
    {
      name                       = "Allow-SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-HTTPS"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}
```

#### FortiGate/fortiManager/FortiAnalyzer Deployment Example

```hcl
module "single_vm" {
  source = "fortinetdev/cloud-modules/azurerm/modules/fortinet/generic_vm_standalone"

  azure_subscription_id = "YOUR_OWN_VALUE"

  # prefix used for all top level resources
  prefix = "single_fortigate_test"

  # Only needed if you'd like to use the existing resources.
  # resource_group_name  = "YOUR_OWN_VALUE"
  # virtual_network_name = "YOUR_OWN_VALUE"
  # subnet_name          = "YOUR_OWN_VALUE"

  location = "Central US"

  # Only needed if you'd like to create new vnet and subnet (not using the existing resources.) Your own values for vnet_address_space and subnet_address_prefixes. Default values will be used if not provided.
  vnet_address_space      = ["10.0.0.0/16"]
  subnet_address_prefixes = ["10.0.1.0/24"]

  # username and password required for the Azure VM
  admin_username = "YOUR_OWN_VALUE"
  admin_password = "Your_Own_Strong_Password_123!"

  # network_interfaces, set public_IP_creation_flag to true will creat a piblic IP. Define more interfaces as needed.
  network_interfaces = [
    {
      name                    = "port1"
      public_IP_creation_flag = true
    },
    {
      name = "port2"
    }
  ]

  nsg_rules = [
    {
      name                       = "Allow-SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-HTTPS"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  # Check the product name in /docs/generic_vm_standalone.md
  product_name  = "fortigate" # fortimanager, fortianalyzer
  image_version = "7.6.6"
  vm_size       = "Standard_D2s_v3" # vm size may vary for different products.

  # Provide either file license or flextoken.
  # license_file_path      = "YOUR_OWN_VALUE" # e.g. "./license.lic"
  # license_fortiflex      = "YOUR_OWN_VALUE"

  # Provide the file path if you have any additional custom config.
  # custom_data_file_path = "YOUR_OWN_VALUE" # e.g. "./custom_data.conf"
}
```

#### Output Info

```hcl
# The output info for the deployed instance. Modify the output as needed.
output "instance_info" {
  description = "The public IP address of the instance VM"
  value       = module.single_vm
}
```

**Post-Deployment: Instance Information**

Once the deployment is complete, Terraform will display the following information:

Public IP Address: The public IP assigned to the instance.
Network Interfaces: The associated network interfaces for the VM.
This output can be helpful for connecting to the VM and verifying the deployment.

Feel free to output more info as needed.

The FortiAIOps instance may take longer to initialize compared to other products. Please allow some time after deployment before accessing the VM via SSH or GUI.
