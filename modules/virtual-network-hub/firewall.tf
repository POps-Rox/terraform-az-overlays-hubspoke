# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#--------------------------------------------------------------------------------------------------------
# Firewall Creation with subnets.
#--------------------------------------------------------------------------------------------------------

#---------------------------------------------------------
# Firewall Subnet Creation or selection
#----------------------------------------------------------
resource "azurerm_subnet" "fw_client_snet" {
  count                = var.enable_firewall ? 1 : 0
  name                 = "AzureFirewallSubnet"
  resource_group_name  = module.mod_hub_rg.0.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.fw_client_snet_address_prefix
  service_endpoints    = var.fw_client_snet_service_endpoints
  # azurerm 4.x replaced `private_endpoint_network_policies_enabled` (bool) with
  # `private_endpoint_network_policies` (string enum). Module variable preserved (bool);
  # converted at the resource boundary.
  private_endpoint_network_policies             = var.fw_client_snet_private_endpoint_network_policies_enabled == null ? null : (var.fw_client_snet_private_endpoint_network_policies_enabled ? "Enabled" : "Disabled")
  private_link_service_network_policies_enabled = var.fw_client_snet_private_link_service_network_policies_enabled
}

#---------------------------------------------------------
# Firewall Managemnet Subnet Creation
#----------------------------------------------------------
resource "azurerm_subnet" "fw_management_snet" {
  count                = (var.enable_forced_tunneling && var.fw_management_snet_address_prefix != null) ? 1 : 0
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = module.mod_hub_rg.0.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.fw_management_snet_address_prefix
  service_endpoints    = var.fw_management_snet_service_endpoints
  # See note above re: 4.x rename.
  private_endpoint_network_policies             = var.fw_management_snet_private_endpoint_network_policies_enabled == null ? null : (var.fw_management_snet_private_endpoint_network_policies_enabled ? "Enabled" : "Disabled")
  private_link_service_network_policies_enabled = var.fw_management_snet_private_link_service_network_policies_enabled
}

#------------------------------------------
# Public IP resources for Azure Firewall
#------------------------------------------
resource "azurerm_public_ip_prefix" "fw-pref" {
  count               = var.enable_firewall ? 1 : 0
  name                = lower("${local.hub_fw_name}-prefix")
  resource_group_name = module.mod_hub_rg.0.resource_group_name
  location            = module.mod_hub_rg.0.resource_group_location
  prefix_length       = 30
  tags                = merge({ "ResourceName" = lower("${local.hub_fw_name}-prefix") }, var.tags, )
}

resource "azurerm_public_ip" "firewall_client_pip" {
  count               = var.enable_firewall ? 1 : 0
  name                = local.hub_fw_client_pip_name
  location            = module.mod_hub_rg.0.resource_group_location
  resource_group_name = module.mod_hub_rg.0.resource_group_name
  allocation_method   = var.fw_pip_allocation_method
  sku                 = var.fw_pip_sku
  tags                = var.tags
}

resource "azurerm_public_ip" "firewall_management_pip" {
  count               = var.enable_forced_tunneling ? 1 : 0
  name                = local.hub_fw_mgt_pip_name
  location            = module.mod_hub_rg.0.resource_group_location
  resource_group_name = module.mod_hub_rg.0.resource_group_name
  allocation_method   = var.fw_pip_allocation_method
  sku                 = var.fw_pip_sku
  tags                = var.tags
}

#-----------------
# Azure Firewall 
#-----------------
resource "azurerm_firewall" "fw" {
  count               = var.enable_firewall ? 1 : 0
  name                = local.hub_fw_name
  resource_group_name = module.mod_hub_rg.0.resource_group_name
  location            = module.mod_hub_rg.0.resource_group_location
  sku_name            = var.firewall_config.sku_name
  sku_tier            = var.firewall_config.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.firewallpolicy.id
  dns_servers         = var.firewall_config.dns_servers
  private_ip_ranges   = var.firewall_config.private_ip_ranges
  threat_intel_mode   = lookup(var.firewall_config, "threat_intel_mode", "Alert")
  zones               = var.firewall_config.zones
  tags                = merge({ "ResourceName" = format("%s", local.hub_fw_name) }, var.tags, )

  ip_configuration {
    name                 = lower("${local.hub_fw_name}-ipconfig")
    subnet_id            = azurerm_subnet.fw_client_snet.0.id
    public_ip_address_id = azurerm_public_ip.firewall_client_pip.0.id
  }

  dynamic "management_ip_configuration" {
    for_each = var.enable_forced_tunneling ? [1] : []
    content {
      name                 = lower("${local.hub_fw_name}-forced-tunnel")
      subnet_id            = azurerm_subnet.fw_management_snet.0.id
      public_ip_address_id = azurerm_public_ip.firewall_management_pip[0].id
    }
  }

  dynamic "virtual_hub" {
    for_each = var.virtual_hub != null ? [var.virtual_hub] : []
    content {
      virtual_hub_id  = virtual_hub.value.virtual_hub_id
      public_ip_count = virtual_hub.value.public_ip_count
    }
  }
}

#----------------------------------------------
# Azure Firewall Network/Application/NAT Rules 
#----------------------------------------------
/* resource "azurerm_firewall_application_rule_collection" "fw_app" {
  for_each            = local.fw_application_rules
  name                = lower(format("fw-app-rule-%s-${var.hub_vnet_name}-${local.location}", each.key))
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = local.resource_group_name
  priority            = 100 * (each.value.idx + 1)
  action              = each.value.rule.action

  rule {
    name             = each.key
    source_addresses = each.value.rule.source_addresses
    target_fqdns     = each.value.rule.target_fqdns

    protocol {
      type = each.value.rule.protocol.type
      port = each.value.rule.protocol.port
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "fw" {
  for_each            = local.fw_network_rules
  name                = lower(format("fw-net-rule-%s-${var.hub_vnet_name}-${local.location}", each.key))
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = local.resource_group_name
  priority            = 100 * (each.value.idx + 1)
  action              = each.value.rule.action

  rule {
    name                  = each.key
    source_addresses      = each.value.rule.source_addresses
    destination_ports     = each.value.rule.destination_ports
    destination_addresses = [for dest in each.value.rule.destination_addresses : contains(var.public_ip_names, dest) ? azurerm_public_ip.fw-pip[dest].ip_address : dest]
    protocols             = each.value.rule.protocols
  }
}

resource "azurerm_firewall_nat_rule_collection" "fw" {
  for_each            = local.fw_nat_rules
  name                = lower(format("fw-nat-rule-%s-${var.hub_vnet_name}-${local.location}", each.key))
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = local.resource_group_name
  priority            = 100 * (each.value.idx + 1)
  action              = each.value.rule.action

  rule {
    name                  = each.key
    source_addresses      = each.value.rule.source_addresses
    destination_ports     = each.value.rule.destination_ports
    destination_addresses = [for dest in each.value.rule.destination_addresses : contains(var.public_ip_names, dest) ? azurerm_public_ip.fw-pip[dest].ip_address : dest]
    protocols             = each.value.rule.protocols
    translated_address    = each.value.rule.translated_address
    translated_port       = each.value.rule.translated_port
  }
} */


