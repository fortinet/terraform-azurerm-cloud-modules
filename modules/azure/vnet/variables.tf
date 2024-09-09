variable "resource_group_name" {
  description = "The name of the Resource Group where the related resources will be placed."
  type        = string
}

variable "location" {
  description = "The location where the resources will be deployed."
  type        = string
}

variable "create_virtual_network" {
  description = "If set to true, create a new Virtual Network; otherwise, use an existing network."
  type        = bool
  default     = true
}

variable "vnet_name" {
  description = "The name of the Azure Virtual Network."
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network. Multiple address spaces are supported."
  type        = list(string)
}

variable "create_subnets" {
  description = "If set to true, create new subnets within the Vnet; otherwise, use an existing subnets."
  type        = bool
  default     = true
}

variable "subnets" {
  description = <<-EOF
  Subnets to be created within a Vnet.
  Options:
  - name                            (Required|string) The name of a subnet.
  - address_prefixes                (Required|string) The address prefix to use for the subnet. Only required when a subnet will be created.
  - network_security_group          (Required|string) The Network Security Group identifier to associate with the subnet.
  - enable_storage_service_endpoint (Optional|boolean) A flag that enables the Microsoft.Storage service endpoint on a subnet. This is recommended for management interfaces when full bootstrapping with an Azure Storage Account is used. The default value is false.

  Example:
  ```
  {
    "public" = {
      name                   = "public-subnet"
      address_prefixes       = ["192.168.1.0/25"]
      network_security_group = "public_network_security_group"
      route_table            = "public_route_table"
    },
    "private" = {
      name                   = "private-subnet"
      address_prefixes       = ["192.168.1.128/25"]
      network_security_group = "private_network_security_group"
      route_table            = "private_route_table"
    }
  }
  ```
  EOF
}

variable "network_security_groups" {
  description = <<-EOF
  Manages a network security group that contains a list of network security rules. Network security groups enable inbound or outbound traffic to be enabled or denied.
  Options:
  - name      (Required|string) The name of the Network Security Group.
  - location  (Optional) Specifies the Azure location where to deploy the resource.
  - rules     (Optional) A list of objects representing a Network Security Rule.

    Options for rules:
      - priority                     (Optional|number) Numeric priority of the rule. The value can be between 100 and 4096 and must be unique for each rule.
      - direction                    (Optional|string) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are `Inbound and `Outbound`.
      - access                       (Optional|string) Specifies whether network traffic is allowed or denied. Possible values are `Allow and `Deny`.
      - protocol                     (Optional|string) Network protocol this rule applies to. Possible values include `Tcp`, `Udp`, `Icmp`, or `* (which matches all).
      - source_port_range            (Optional|string) A source port or a range of ports. This can also be an `* to match all.
      - source_port_ranges           (Optional|list) A list of source ports or ranges of ports. This can be specified only if `source_port_range was not used.
      - destination_port_range       (Optional|string) A destination port or a range of ports. This can also be an `* to match all.
      - destination_port_ranges      (Optional|list) A list of destination ports or a ranges of ports. This can be specified only if `destination_port_range was not used.
      - source_address_prefix        (Optional|string) Source CIDR or IP range or `* to match any IP.
      - source_address_prefixes      (Optional|list) A list of source address prefixes. Can be specified only if `source_address_prefix was not used.
      - destination_address_prefix   (Optional|string) Destination CIDR or IP range or `* to match any IP.
      - destination_address_prefixes (Optional|list) A list of destination address prefixes. Can be specified only if `destination_address_prefix was not used.

  Example:
  ```
  {
    "allow_all_inbound" = {
      name = "all_inbound_nsg"
      location = "centralus"
      rules = {
        "Inbound" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          source_address_prefix      = "*"
          destination_port_range     = "*"
          destination_address_prefix = "*"
        }
      }
    }
  }
  ```
  EOF
}

variable "tags" {
  description = "Tags for the resources created."
  type        = map(any)
  default     = {}
}
