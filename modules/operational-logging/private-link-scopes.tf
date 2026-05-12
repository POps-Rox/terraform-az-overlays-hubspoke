# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_monitor_private_link_scope" "global_pls" {
  name                = local.privateLinkScopeName
  resource_group_name = module.mod_logging_rg[0].resource_group_name
}

resource "azurerm_monitor_private_link_scoped_service" "laws_pls" {
  depends_on = [
    azurerm_monitor_private_link_scope.global_pls,
    azurerm_log_analytics_workspace.loganalytics
  ]
  name                = local.privateLinkScopeResourceName
  resource_group_name = module.mod_logging_rg[0].resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.global_pls.name
  linked_resource_id  = azurerm_log_analytics_workspace.loganalytics.id
}


