# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#--------------------------------------------------------------------------------------------------------
# Subnets Creation with, private link endpoint/servie network policies, service endpoints and Deligation.
#--------------------------------------------------------------------------------------------------------

resource "azurerm_subnet" "default_snet" {
  name                 = local.spoke_snet_name
  resource_group_name  = module.mod_spoke_rg.0.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = var.spoke_subnet_address_prefix
  service_endpoints    = var.spoke_subnet_service_endpoints
  # azurerm 4.x: `private_endpoint_network_policies_enabled` (bool) → `private_endpoint_network_policies` (string enum).
  # Module variables kept as bool for backward compatibility; converted here.
  private_endpoint_network_policies             = var.spoke_private_endpoint_network_policies_enabled == null ? null : (var.spoke_private_endpoint_network_policies_enabled ? "Enabled" : "Disabled")
  private_link_service_network_policies_enabled = var.spoke_private_link_service_network_policies_enabled
}

resource "azurerm_subnet" "additional_snets" {
  for_each             = var.add_subnets
  name                 = lower(format("${var.org_name}-${module.mod_azregions.location_cli}-%s-snet", each.value.name))
  resource_group_name  = module.mod_spoke_rg.0.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = lookup(each.value, "service_endpoints", [])
  # 4.x rename — see note above. Map key remains bool for backward compatibility.
  private_endpoint_network_policies             = lookup(each.value, "private_endpoint_network_policies_enabled", null) == null ? null : (lookup(each.value, "private_endpoint_network_policies_enabled") ? "Enabled" : "Disabled")
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", null)

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {}) != {} ? [1] : []
    content {
      name = lookup(each.value.delegation, "name", null)
      service_delegation {
        name    = lookup(each.value.delegation.service_delegation, "service_delegation_name", null)
        actions = lookup(each.value.delegation.service_delegation, "service_delegation_actions", null)
      }
    }
  }
}
