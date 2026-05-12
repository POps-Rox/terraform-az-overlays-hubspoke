# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Terraform Module to deploy the Hub Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment
              * Hub Network Virtual Network              
AUTHOR/S: jspinella
*/

#-------------------------------------
# VNET Creation - Default is "true"
#-------------------------------------
resource "azurerm_virtual_network" "spoke_vnet" {
  depends_on = [
    module.mod_spoke_rg
  ]
  name                = local.spoke_vnet_name
  location            = module.mod_spoke_rg[0].resource_group_location
  resource_group_name = module.mod_spoke_rg[0].resource_group_name
  address_space       = var.virtual_network_address_space
  dns_servers         = var.dns_servers
  tags                = merge({ "ResourceName" = format("%s", local.spoke_vnet_name) }, var.tags, )
}

#-------------------------------------
# Network Watcher - Default is "true"
#-------------------------------------
# tflint-ignore: terraform_unused_declarations  # WIP: NetworkWatcherRG lookup not yet referenced by downstream resources. See issue #12.
data "azurerm_resource_group" "netwatch" {
  count = var.is_spoke_deployed_to_same_hub_subscription == true ? 1 : 0
  name  = "NetworkWatcherRG"
}

resource "azurerm_resource_group" "nwatcher" {
  count    = var.is_spoke_deployed_to_same_hub_subscription == false ? 1 : 0
  name     = "NetworkWatcherRG"
  location = var.location
  tags     = merge({ "ResourceName" = "NetworkWatcherRG" }, var.tags, )
}

resource "azurerm_network_watcher" "nwatcher" {
  count               = var.is_spoke_deployed_to_same_hub_subscription == false ? 1 : 0
  name                = "NetworkWatcher_${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.nwatcher[0].name
  tags                = merge({ "ResourceName" = format("%s", "NetworkWatcher_${var.location}") }, var.tags, )
}
