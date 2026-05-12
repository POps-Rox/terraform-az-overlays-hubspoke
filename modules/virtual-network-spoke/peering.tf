# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#-----------------------------------------------
# Peering between Hub and Spoke Virtual Network
#-----------------------------------------------
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = lower("peering-${azurerm_virtual_network.spoke_vnet.name}-to-${element(split("/", var.hub_virtual_network_id), 8)}")
  resource_group_name          = module.mod_spoke_rg[0].resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id    = var.hub_virtual_network_id
  allow_virtual_network_access = var.allow_virtual_spoke_network_access
  allow_forwarded_traffic      = var.allow_forwarded_spoke_traffic
  allow_gateway_transit        = var.allow_gateway_spoke_transit
  use_remote_gateways          = var.use_remote_spoke_gateway
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider                     = azurerm.hub_network
  name                         = lower("peering-${element(split("/", var.hub_virtual_network_id), 8)}-to-spoke-${azurerm_virtual_network.spoke_vnet.name}")
  resource_group_name          = element(split("/", var.hub_virtual_network_id), 4)
  virtual_network_name         = element(split("/", var.hub_virtual_network_id), 8)
  remote_virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
  allow_gateway_transit        = true
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  use_remote_gateways          = false
}
