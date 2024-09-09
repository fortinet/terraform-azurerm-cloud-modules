locals {
  virtual_network = var.create_virtual_network ? azurerm_virtual_network.vnet[0] : data.azurerm_virtual_network.data_vnet[0]
  subnets         = var.create_subnets ? azurerm_subnet.subnet : data.azurerm_subnet.data_subnet
}

resource "azurerm_virtual_network" "vnet" {
  count               = var.create_virtual_network ? 1 : 0
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

data "azurerm_virtual_network" "data_vnet" {
  count               = var.create_virtual_network == false ? 1 : 0
  resource_group_name = var.resource_group_name
  name                = var.vnet_name
}

resource "azurerm_subnet" "subnet" {
  for_each             = { for k, v in var.subnets : k => v if var.create_subnets }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = try(each.value.enable_storage_service_endpoint, false) ? ["Microsoft.Storage"] : null
}

data "azurerm_subnet" "data_subnet" {
  for_each             = { for k, v in var.subnets : k => v if var.create_subnets == false }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = local.virtual_network.name
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.network_security_groups
  name                = each.value.name
  location            = try(each.value.location, var.location)
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

locals {
  nsg_rules = flatten([
    for nsg_key, nsg in var.network_security_groups : [
      for rule_name, rule in lookup(nsg, "rules", {}) : {
        nsg_key   = nsg_key
        nsg_name  = nsg.name
        rule_name = rule_name
        rule      = rule
      }
    ]
  ])
}

resource "azurerm_network_security_rule" "nsg_rule" {
  for_each = {
    for nsg in local.nsg_rules : "${nsg.nsg_key}-${nsg.rule_name}" => nsg
  }
  name                         = each.value.rule_name
  resource_group_name          = var.resource_group_name
  network_security_group_name  = azurerm_network_security_group.nsg[each.value.nsg_key].name
  priority                     = each.value.rule.priority
  direction                    = each.value.rule.direction
  access                       = each.value.rule.access
  protocol                     = each.value.rule.protocol
  source_port_range            = try(each.value.rule.source_port_range, null)
  source_port_ranges           = try(each.value.rule.source_port_ranges, null)
  destination_port_range       = try(each.value.rule.destination_port_range, null)
  destination_port_ranges      = try(each.value.rule.destination_port_ranges, null)
  source_address_prefix        = try(each.value.rule.source_address_prefix, null)
  source_address_prefixes      = try(each.value.rule.source_address_prefixes, null)
  destination_address_prefix   = try(each.value.rule.destination_address_prefix, null)
  destination_address_prefixes = try(each.value.rule.destination_address_prefixes, null)

  depends_on = [azurerm_network_security_group.nsg]
}

resource "azurerm_subnet_network_security_group_association" "nsg_asso" {
  for_each                  = { for k, v in var.subnets : k => v if can(v.network_security_group) }
  subnet_id                 = local.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.network_security_group].id
}
