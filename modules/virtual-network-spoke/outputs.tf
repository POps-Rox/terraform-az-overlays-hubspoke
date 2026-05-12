# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "resource_group_name" {
  description = "The name of the spoke virtual network resource group"
  value       = azurerm_virtual_network.spoke_vnet.resource_group_name
}

output "virtual_network_name" {
  description = "The name of the spoke virtual network"
  value       = azurerm_virtual_network.spoke_vnet.name
}

output "virtual_network_id" {
  description = "The id of the spoke virtual network"
  value       = azurerm_virtual_network.spoke_vnet.id
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = element(coalescelist(azurerm_virtual_network.spoke_vnet[*].address_space, [""]), 0)
}

output "network_watcher_id" {
  description = "ID of Network Watcher"
  value       = var.is_spoke_deployed_to_same_hub_subscription == false ? element(concat(azurerm_network_watcher.nwatcher[*].id, [""]), 0) : null
}

output "nsg_id" {
  description = "The id of the spoke nsg"
  value       = azurerm_network_security_group.nsg.id
}

output "nsg_name" {
  description = "The name of the spoke nsg"
  value       = azurerm_network_security_group.nsg.name
}

output "default_subnet_id" {
  description = "The id of the default subnet"
  value       = azurerm_subnet.default_snet.id
}

output "default_subnet_name" {
  description = "The id of the default subnet"
  value       = azurerm_subnet.default_snet.name
}
