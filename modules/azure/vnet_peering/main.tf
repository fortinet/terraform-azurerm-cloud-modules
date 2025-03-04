data "azurerm_virtual_network" "provider_vnet" {
  name                = var.provider_vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_virtual_network" "spoke_vnet" {
  name                = var.spoke_vnet_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network_peering" "provider_to_spoke" {
  name                         = "${var.provider_vnet_name}-to-${var.spoke_vnet_name}"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.provider_vnet_name
  remote_virtual_network_id    = data.azurerm_virtual_network.spoke_vnet.id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
}

resource "azurerm_virtual_network_peering" "spoke_to_provider" {
  name                         = "${var.spoke_vnet_name}-to-${var.provider_vnet_name}"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.spoke_vnet_name
  remote_virtual_network_id    = data.azurerm_virtual_network.provider_vnet.id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
}

resource "azurerm_route_table" "subnet_route_tables" {
  for_each            = var.subnet_routes
  name                = "${each.key}-route"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "route" {
    for_each = each.value
    iterator = route
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }

  }
}

data "azurerm_subnet" "subnets" {
  for_each             = var.subnet_routes
  name                 = each.key
  virtual_network_name = var.spoke_vnet_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_subnet_route_table_association" "subnet_route_table_associations" {
  for_each       = var.subnet_routes
  subnet_id      = data.azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.subnet_route_tables[each.key].id

  lifecycle {
    ignore_changes = [route_table_id]
  }
}
