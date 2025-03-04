Deploying a single FortiGate VM on Azure

**Introduction**

This module, located at /modules/fortigate/single_fgt, allows you to deploy a single FortiGate Virtual Machine on Azure. You can use the module directly by following the steps below.

**Deployment Steps**

1. Copy the example module below to your local and provide all the required values in it.
2. It offers both `payg` and `byol` license types. If you prefer to use `payg` license type, there's no extra license info needed. Otherwise, please provide either file-license or fortiflex info in the below module.
3. Run the following commands:

   ```sh
   terraform init
   terraform apply
   ```

Example Module:

```
module "single_fortigate_vm" {
  source = "fortinetdev/cloud-modules/azurerm/modules/fortigate/single_fgt"

  azure_subscription_id = "YOUR_OWN_VALUE"

  # prefix used for all top level resources.
  prefix = "single_fgt"

  # Only needed if you'd like to use the existing resources.
  # resource_group_name  = "YOUR_OWN_VALUE"
  # virtual_network_name = "YOUR_OWN_VALUE"
  # subnet_name          = "YOUR_OWN_VALUE"

  location = "Central US"

  # Only needed if you'd like to create new vnet and subnet (not using the existing resources.) Your own values for vnet_address_space and subnet_address_prefixes. Default values will be used if not provided.
  vnet_address_space      = ["10.0.0.0/16"]
  subnet_address_prefixes = ["10.0.1.0/24"]

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

  # FortiGate info
  admin_username = "fgtadmin"
  admin_password = "Example_single_fgt@!"

  image_sku     = "fortinet_fg-vm_payg_2023" # "fortinet_fg-vm_payg_2023" for PAYG or "fortinet_fg-vm" for BYOL. Please use the command az vm image list -o table --all --publisher fortinet --offer fortinet_fortigate-vm_v5 to show all the supported image_sku.
  image_version = "7.6.0"

  # Provide either file license or flextoken when using image_sku = fortinet_fg-vm
  # fgt_license_file_path      = "YOUR_OWN_VALUE" # e.g. "./license.lic"
  # fgt_license_fortiflex      = "YOUR_OWN_VALUE"

  # Provide the file path if you have any additional custom config.
  # fgt_custom_data_file_path = "YOUR_OWN_VALUE" # e.g. "./custom_data.conf"
}

# The output info for the FortiGate instance. Modify the output as needed.
output "fortigate_info" {
  description = "The public IP address of the FortiGate VM"
  value       = module.single_fortigate_vm
}
```

**Post-Deployment: FortiGate Instance Information**

Once the deployment is complete, Terraform will display the following information:

Public IP Address: The public IP assigned to the FortiGate instance.
Network Interfaces: The associated network interfaces for the VM.
This output can be helpful for connecting to the FortiGate VM and verifying the deployment.

Feel free to output more info as needed.
