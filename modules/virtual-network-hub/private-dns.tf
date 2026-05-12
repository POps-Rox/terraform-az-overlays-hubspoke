# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Create the DNS zones
resource "azurerm_private_dns_zone" "privatelink_monitor_azure_com" {
  depends_on = [
    azurerm_virtual_network.hub_vnet
  ]
  name                = local.privateDnsZones_privatelink_monitor_azure_name
  resource_group_name = module.mod_hub_rg[0].resource_group_name
}

resource "azurerm_private_dns_zone" "privatelink_oms_opinsights_azure_com" {
  depends_on = [
    azurerm_virtual_network.hub_vnet
  ]
  name                = local.privateDnsZones_privatelink_oms_opinsights_azure_name
  resource_group_name = module.mod_hub_rg[0].resource_group_name
}

resource "azurerm_private_dns_zone" "privatelink_ods_opinsights_azure_com" {
  depends_on = [
    azurerm_virtual_network.hub_vnet
  ]
  name                = local.privateDnsZones_privatelink_ods_opinsights_azure_name
  resource_group_name = module.mod_hub_rg[0].resource_group_name
}

resource "azurerm_private_dns_zone" "privatelink_agentsvc_azure_automation_net" {
  depends_on = [
    azurerm_virtual_network.hub_vnet
  ]
  name                = local.privateDnsZones_privatelink_agentsvc_azure_automation_name
  resource_group_name = module.mod_hub_rg[0].resource_group_name
}

resource "azurerm_private_dns_zone" "privatelink_blob_core_cloudapi_net" {
  depends_on = [
    azurerm_virtual_network.hub_vnet
  ]
  name                = local.privateDnsZones_privatelink_blob_core_cloudapi_net_name
  resource_group_name = module.mod_hub_rg[0].resource_group_name
}

# Link the DNS zones to the hub virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_monitor_azure_com_privatelink_monitor_azure_com_link" {
  depends_on = [
    azurerm_virtual_network.hub_vnet,
    azurerm_private_dns_zone.privatelink_monitor_azure_com
  ]
  name                  = "${azurerm_virtual_network.hub_vnet.name}-${local.privateDnsZones_privatelink_monitor_azure_name}-link"
  resource_group_name   = module.mod_hub_rg[0].resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_monitor_azure_com.name
  virtual_network_id    = azurerm_virtual_network.hub_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_oms_opinsights_azure_com_privatelink_oms_opinsights_azure_com_link" {
  depends_on = [
    azurerm_private_dns_zone.privatelink_oms_opinsights_azure_com,
    azurerm_private_dns_zone_virtual_network_link.privatelink_monitor_azure_com_privatelink_monitor_azure_com_link
  ]
  name                  = "${azurerm_virtual_network.hub_vnet.name}-${local.privateDnsZones_privatelink_oms_opinsights_azure_name}-link"
  resource_group_name   = module.mod_hub_rg[0].resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_oms_opinsights_azure_com.name
  virtual_network_id    = azurerm_virtual_network.hub_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_ods_opinsights_azure_com_privatelink_ods_opinsights_azure_com_link" {
  depends_on = [
    azurerm_private_dns_zone.privatelink_ods_opinsights_azure_com,
    azurerm_private_dns_zone_virtual_network_link.privatelink_oms_opinsights_azure_com_privatelink_oms_opinsights_azure_com_link
  ]
  name                  = "${azurerm_virtual_network.hub_vnet.name}-${local.privateDnsZones_privatelink_ods_opinsights_azure_name}-link"
  resource_group_name   = module.mod_hub_rg[0].resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_ods_opinsights_azure_com.name
  virtual_network_id    = azurerm_virtual_network.hub_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_agentsvc_azure_automation_net_privatelink_agentsvc_azure_automation_net_link" {
  depends_on = [
    azurerm_private_dns_zone.privatelink_agentsvc_azure_automation_net,
    azurerm_private_dns_zone_virtual_network_link.privatelink_ods_opinsights_azure_com_privatelink_ods_opinsights_azure_com_link
  ]
  name                  = "${azurerm_virtual_network.hub_vnet.name}-${local.privateDnsZones_privatelink_agentsvc_azure_automation_name}-link"
  resource_group_name   = module.mod_hub_rg[0].resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_agentsvc_azure_automation_net.name
  virtual_network_id    = azurerm_virtual_network.hub_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "privateDnsZones_privatelink_blob_core_cloudapi_net_privateDnsZones_privatelink_blob_core_cloudapi_net_link" {
  depends_on = [
    azurerm_private_dns_zone.privatelink_blob_core_cloudapi_net,
    azurerm_private_dns_zone_virtual_network_link.privatelink_agentsvc_azure_automation_net_privatelink_agentsvc_azure_automation_net_link
  ]
  name                  = "${azurerm_virtual_network.hub_vnet.name}-${local.privateDnsZones_privatelink_blob_core_cloudapi_net_name}-link"
  resource_group_name   = module.mod_hub_rg[0].resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_blob_core_cloudapi_net.name
  virtual_network_id    = azurerm_virtual_network.hub_vnet.id
}
