Terraform Modules for Deploying FortiGate VMSS with external load balancer and GWLB on Azure

**Introduction**

The `applb_gwlb_fgtasg` example demonstrates the integration of a FortiGate Virtual Machine Scale Set with Azure Gateway Load Balancer for seamless traffic inspection of consumer applications. Traffic from a standard load balancer, which fronts consumer applications, is redirected to the Gateway Load Balancer (GWLB) for inspection. FortiGate VMs can be shared across multiple applications, even those in different subscriptions, allowing for traffic inspection with minimal changes when new consumer applications are added. This integration enables managed security service providers to deliver advanced threat protection through FortiGate VMs deployed behind the GWLB, offering comprehensive security across various consumer applications.

**Design**

The Gateway Load Balancer and its backend pool serve as an intermediary between the frontend and backend of the Standard Load Balancer (SLB). This configuration ensures that all traffic passing through the SLB is routed to the Gateway Load Balancer for inspection by the FortiGate Virtual Machine Scale Set. The provided example focuses on the provider's virtual network (VNet), which has GateWay Load Balancer and FortiGate Virtual Machine Scale Set behind it, along with the Standard Load Balancer connected with the GWLB (Optional). You can integrate the provider's VNet with your own VNet by using the `gwlb_frontend_ip_configuration_id`.

**Deployment**

Before deploying the example, users should review the `examples/terraform.tfvars.txt` file to ensure all required values are provided and to adjust any settings to fit their specific project needs.

**Direct Use of Example:**

1. Navigate to the example folder (e.g., `examples/applb_gwlb_fgtasg`).
2. Review the variables in the file `terraform.tfvars.template` and provide all the required values in it.
3. Rename the file `terraform.tfvars.template` to `terraform.tfvars`.
4. Run the following commands:

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
