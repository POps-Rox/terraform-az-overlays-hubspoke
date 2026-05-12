# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Hub Logging Storage Account Creation
#----------------------------------------------------------
resource "azurerm_storage_account" "storeacc" {
  name                       = local.hub_sa_name
  resource_group_name        = module.mod_hub_rg.0.resource_group_name
  location                   = module.mod_hub_rg.0.resource_group_location
  account_kind               = "StorageV2"
  account_tier               = "Standard"
  account_replication_type   = "GRS"
  https_traffic_only_enabled = true
  tags                       = merge({ "ResourceName" = format("%s", local.hub_sa_name) }, var.tags, )
}
