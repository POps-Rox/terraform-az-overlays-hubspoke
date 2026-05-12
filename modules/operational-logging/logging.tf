# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Operations Logging Storage Account Creation
#----------------------------------------------------------
resource "azurerm_storage_account" "loganalytics_sa" {
  name                       = local.ops_logging_sa_name
  resource_group_name        = module.mod_logging_rg.0.resource_group_name
  location                   = module.mod_logging_rg.0.resource_group_location
  account_kind               = "StorageV2"
  access_tier                = "Hot"
  account_tier               = "Standard"
  account_replication_type   = "GRS"
  https_traffic_only_enabled = true
  tags                       = merge({ "ResourceName" = format("%s", local.ops_logging_sa_name) }, var.tags, )
}

#---------------------------------------------------------
# Operations Log Analytics Workspace Creation
#----------------------------------------------------------
resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = local.ops_logging_law_name
  location            = module.mod_logging_rg.0.resource_group_location
  resource_group_name = module.mod_logging_rg.0.resource_group_name
  sku                 = var.log_analytics_workspace_sku == null ? "PerGB2018" : var.log_analytics_workspace_sku
  retention_in_days   = var.log_analytics_logs_retention_in_days == null ? 30 : var.log_analytics_logs_retention_in_days
  tags                = merge({ "ResourceName" = format("%s", local.ops_logging_law_name) }, var.tags, )
}

#---------------------------------------------------------
# Operations Log Analytics Workspace Creation
#----------------------------------------------------------
resource "azurerm_log_analytics_solution" "loganalytics_sentinel" {
  count                 = var.enable_sentinel ? 1 : 0
  solution_name         = "SecurityInsights"
  location              = module.mod_logging_rg.0.resource_group_location
  resource_group_name   = module.mod_logging_rg.0.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics.id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
  tags = merge({ "ResourceName" = format("%s", local.ops_logging_law_name) }, var.tags, )
}
