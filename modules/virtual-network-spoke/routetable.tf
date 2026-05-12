# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_route_table" "routetable" {
  depends_on = [
    module.mod_spoke_rg
  ]
  name                = local.spoke_rt_name
  resource_group_name = module.mod_spoke_rg.0.resource_group_name
  location            = module.mod_spoke_rg.0.resource_group_location
  # azurerm 4.x renamed `disable_bgp_route_propagation` to `bgp_route_propagation_enabled`
  # and inverted its semantics. Module variable kept for backward compatibility.
  bgp_route_propagation_enabled = !var.disable_bgp_route_propagation
  tags                          = var.tags
}

resource "azurerm_subnet_route_table_association" "rtassoc" {
  subnet_id      = azurerm_subnet.default_snet.id
  route_table_id = azurerm_route_table.routetable.id
}

resource "azurerm_subnet_route_table_association" "rtaddassoc" {
  for_each       = var.add_subnets
  subnet_id      = azurerm_subnet.additional_snets[each.key].id
  route_table_id = azurerm_route_table.routetable.id
}

resource "azurerm_route" "force_internet_tunneling" {
  name                   = "InternetForceTunneling"
  resource_group_name    = module.mod_spoke_rg.0.resource_group_name
  route_table_name       = azurerm_route_table.routetable.name
  address_prefix         = "0.0.0.0/0"
  next_hop_in_ip_address = var.hub_firewall_private_ip_address
  next_hop_type          = "VirtualAppliance"

  count = var.enable_forced_tunneling_on_route_table ? 1 : 0
}

resource "azurerm_route" "route" {
  for_each               = var.route_table_routes
  name                   = lower("route-to-firewall-${each.value.name}-${module.mod_spoke_rg.0.resource_group_location}")
  resource_group_name    = module.mod_spoke_rg.0.resource_group_name
  route_table_name       = azurerm_route_table.routetable.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}
