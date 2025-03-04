Terraform Modules for Deploying FortiGate VMSS with external load balancer and internal load balancer on Azure

**Introduction**

The `extlb_fgtasg_intlb` example demonstrates how to integrate a FortiGate Virtual Machine Scale Set (VMSS) with both an External Load Balancer (LB) and an Internal Load Balancer (ILB) within an Azure environment. This design ensures seamless traffic inspection for inbound, outbound, and east-west traffic, providing both security and efficient traffic management for Azure-hosted services.

The FortiGate instances in the VMSS actively communicate with each other and the Azure fabric, ensuring consistent inspection of network traffic. This design is particularly effective for environments that require a high level of security, such as enterprise applications or services that handle sensitive data.

This example leverages User Defined Routing (UDR) to guide traffic to the FortiGate VMSS for inspection. Azure’s public and internal Load Balancers direct traffic destined for the FortiGate firewall, allowing all inbound, outbound, and east-west traffic to be inspected before proceeding to their destinations.

`Inbound Traffic`: Traffic originating from the internet or on-premises networks, targeting services published via the Azure Load Balancer.
`Outbound Traffic`: Traffic originating from the internal Azure network (peered VNETs) destined for external internet services.
`East-West Traffic`: Traffic flowing between peered virtual networks within the Azure environment.

The design provides flexibility, allowing you to choose whether East-West traffic should be inspected by FortiGate through the configurable `enable_east_west_traffic` parameter.

**Deployment**

Before deploying the example, users should review the `examples/terraform.tfvars.template` file to ensure all required values are provided and to adjust any settings to fit their specific project needs.

**Direct Use of Example:**

1. Navigate to the example folder (e.g., `examples/extlb_fgtasg_intlb`).
2. Review the variables in the file `terraform.tfvars.template` and provide all the required values in it.
3. Review the file `fortigate_custom_config.conf` and adjust the configurations as required for your environment. When testing inbound traffic, it is essential to update the `extip`, `mappedip`, `extport`, and `mappedport` parameters within the `config firewall vip` configuration. The values provided in the configuration file are for reference only. After the initial deployment, you can modify these parameters as needed and apply the changes to your FortiGate VMs using the `terraform apply` command. For more details, please refer to the `fortigate_custom_config.conf`.
4. Rename the file `terraform.tfvars.template` to `terraform.tfvars`.
5. Run the following commands:

   ```sh
   terraform init
   terraform apply
   ```

**Output FortiGate Info**

The FortiGate Virtual Machine Scale Set includes sensitive information such as passwords. To protect this information, details about the FortiGate VMSS—such as usernames, passwords, and public IPs of all FortiGate instances—are not displayed directly with other output variables.

To view the sensitive information, run the following command:

```sh
terraform output fortigate_instances
```

**Question or Issue**

Open an issue if you have any questions [open an issue](https://github.com/fortinetdev/terraform-azurerm-cloud-modules/issues)

**License**

[License](./LICENSE) © Fortinet Technologies. All rights reserved.