locals {
  resource_group_name  = var.resource_group_creation_flag ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.existing_group[0].name
  virtual_network_name = var.virtual_network_creation_flag ? azurerm_virtual_network.vnet[0].name : data.azurerm_virtual_network.existing_vnet[0].name
  subnet               = var.subnet_creation_flag ? azurerm_subnet.subnet[0] : data.azurerm_subnet.existing_subnet[0]
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_creation_flag ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

data "azurerm_resource_group" "existing_group" {
  count = var.resource_group_creation_flag ? 0 : 1
  name  = try(var.resource_group_name, null)
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  count               = var.virtual_network_creation_flag ? 1 : 0
  name                = "${var.prefix}-vnet"
  location            = var.location
  resource_group_name = local.resource_group_name
  address_space       = try(var.vnet_address_space, ["10.0.0.0/16"])
  tags                = var.tags
}

data "azurerm_virtual_network" "existing_vnet" {
  count               = var.virtual_network_creation_flag ? 0 : 1
  resource_group_name = local.resource_group_name
  name                = try(var.virtual_network_name, null)
}

# Subnet for the FortiGate VM
resource "azurerm_subnet" "subnet" {
  count                = var.subnet_creation_flag ? 1 : 0
  name                 = "${var.prefix}-subnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network_name
  address_prefixes     = try(var.subnet_address_prefixes, ["10.0.1.0/24"])
}

data "azurerm_subnet" "existing_subnet" {
  count                = var.subnet_creation_flag ? 0 : 1
  name                 = try(var.subnet_name, null)
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network_name
}

# Public IP for the FortiGate VM
resource "azurerm_public_ip" "pip" {
  for_each            = { for nic in var.network_interfaces : nic.name => nic if nic.public_IP_creation_flag == true }
  name                = "public-ip-fortigate-${each.key}"
  resource_group_name = local.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface for the FortiGate VM
resource "azurerm_network_interface" "nic" {
  for_each = { for nic in var.network_interfaces : nic.name => nic }

  name                = each.value.name
  location            = var.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "${each.value.name}-ip-config"
    subnet_id                     = var.subnet_creation_flag ? azurerm_subnet.subnet[0].id : data.azurerm_subnet.existing_subnet[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.public_IP_creation_flag ? azurerm_public_ip.pip[each.key].id : null
  }

  depends_on = [
    azurerm_public_ip.pip,
    azurerm_subnet.subnet
  ]
}

# Network Security Group to allow necessary ports
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = var.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "allow-http"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_asso" {
  subnet_id                 = local.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id

  depends_on = [
    azurerm_subnet.subnet,
    azurerm_network_security_group.nsg
  ]
}

resource "azurerm_network_interface_security_group_association" "fortigate_nic_nsg" {
  for_each = azurerm_network_interface.nic

  network_interface_id      = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id

  depends_on = [
    azurerm_network_interface.nic,
    azurerm_network_security_group.nsg
  ]
}

# FortiGate VM
resource "azurerm_linux_virtual_machine" "fortigate" {
  name                = var.vm_name
  resource_group_name = local.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = flatten([
    for nic in azurerm_network_interface.nic : nic.id
  ])

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  plan {
    name      = var.image_sku
    publisher = var.image_publisher
    product   = var.image_offer
  }

  custom_data = base64encode(templatefile("${path.module}/${var.fgt_user_data_template}", {
    fgt_license_fortiflex     = var.fgt_license_fortiflex,
    fgt_license_file_path     = var.fgt_license_file_path,
    fgt_custom_data_file_path = var.fgt_custom_data_file_path
  }))

  os_disk {
    caching                = "ReadWrite"
    storage_account_type   = var.storage_account_type
    disk_encryption_set_id = var.disk_encryption_set_id
  }

  disable_password_authentication = false

  depends_on = [
    azurerm_network_interface.nic,
    azurerm_public_ip.pip,
    azurerm_subnet.subnet,
    azurerm_network_security_group.nsg
  ]


  tags = var.tags
}
