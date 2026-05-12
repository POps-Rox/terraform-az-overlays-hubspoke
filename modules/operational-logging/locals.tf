# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Local declarations
#---------------------------------
resource "random_id" "uniqueString" {
  keepers = {
    # Generate a new id each time we change resourePrefix variable
    org_prefix = var.org_name
    subid      = var.workload_name
  }
  byte_length = 8
}

# Convert the input vars to locals, applying any required
# logic needed before they are used in the module.
# No vars should be referenced elsewhere in the module.
# NOTE: Need to catch error for resource_suffix when
# no value for subscription_id is provided.
/* locals {
  enabled                                      = var.enabled  
  subscription_id                              = coalesce(var.subscription_id, "00000000-0000-0000-0000-000000000000")
  settings                                     = var.settings
  location                                     = var.location
  tags                                         = var.tags
  resource_prefix                              = coalesce(var.resource_prefix, local.root_id)
  resource_suffix                              = length(var.resource_suffix) > 0 ? "-${var.resource_suffix}" : local.empty_string
  existing_resource_group_name                 = var.existing_resource_group_name
  existing_log_analytics_workspace_resource_id = var.existing_log_analytics_workspace_resource_id
  existing_automation_account_resource_id      = var.existing_automation_account_resource_id
  link_log_analytics_to_automation_account     = var.link_log_analytics_to_automation_account
  custom_settings                              = var.custom_settings_by_resource_type
  asc_export_resource_group_name               = coalesce(var.asc_export_resource_group_name, "${local.root_id}-asc-export")
}

# Logic to determine whether specific resources
# should be created by this module
locals {
  deploy_monitoring_settings          = local.settings.log_analytics.enabled
  deploy_monitoring_for_vm            = local.deploy_monitoring_settings && local.settings.log_analytics.config.enable_monitoring_for_vm
  deploy_monitoring_for_vmss          = local.deploy_monitoring_settings && local.settings.log_analytics.config.enable_monitoring_for_vmss
  deploy_monitoring_resources         = local.enabled && local.deploy_monitoring_settings
  deploy_resource_group               = local.deploy_monitoring_resources && local.existing_resource_group_name == local.empty_string
  deploy_log_analytics_workspace      = local.deploy_monitoring_resources && local.existing_log_analytics_workspace_resource_id == local.empty_string
  deploy_log_analytics_linked_service = local.deploy_monitoring_resources && local.link_log_analytics_to_automation_account
  deploy_automation_account           = local.deploy_monitoring_resources && local.existing_automation_account_resource_id == local.empty_string
  deploy_azure_monitor_solutions = {
    AgentHealthAssessment       = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_solution_for_agent_health_assessment
    AntiMalware                 = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_solution_for_anti_malware
    ChangeTracking              = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_solution_for_change_tracking
    Security                    = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_sentinel
    SecurityInsights            = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_sentinel
    ServiceMap                  = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_solution_for_service_map
    SQLAssessment               = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_solution_for_sql_assessment
    SQLVulnerabilityAssessment  = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_solution_for_sql_vulnerability_assessment
    SQLAdvancedThreatProtection = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_solution_for_sql_advanced_threat_detection
    Updates                     = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_solution_for_updates
    VMInsights                  = local.deploy_monitoring_resources && local.settings.log_analytics.config.enable_solution_for_vm_insights
  }
  deploy_security_settings           = local.settings.security_center.enabled
  deploy_defender_for_app_services   = local.settings.security_center.config.enable_defender_for_app_services
  deploy_defender_for_arm            = local.settings.security_center.config.enable_defender_for_arm
  deploy_defender_for_containers     = local.settings.security_center.config.enable_defender_for_containers
  deploy_defender_for_dns            = local.settings.security_center.config.enable_defender_for_dns
  deploy_defender_for_key_vault      = local.settings.security_center.config.enable_defender_for_key_vault
  deploy_defender_for_oss_databases  = local.settings.security_center.config.enable_defender_for_oss_databases
  deploy_defender_for_servers        = local.settings.security_center.config.enable_defender_for_servers
  deploy_defender_for_sql_servers    = local.settings.security_center.config.enable_defender_for_sql_servers
  deploy_defender_for_sql_server_vms = local.settings.security_center.config.enable_defender_for_sql_server_vms
  deploy_defender_for_storage        = local.settings.security_center.config.enable_defender_for_storage
} */

locals {
  # Path: src\terraform\azresources\modules\Microsoft.Security\azureSecurityCenter\main.tf
  # Name: azureSecurityCenter
  # Description: Azure Security Center

  bundle = (var.environment == "public") ? [
    "AppServices",
    "Arm",
    "ContainerRegistry",
    "Containers",
    "Dns",
    "KeyVaults",
    "KubernetesService",
    "OpenSourceRelationalDatabases",
    "SqlServers",
    "SqlServerVirtualMachines",
    "StorageAccounts",
    "VirtualMachines"
    ] : (var.environment == "usgovernment") ? [
    "Arm",
    "ContainerRegistry",
    "Containers",
    "Dns",
    "KubernetesService",
    "OpenSourceRelationalDatabases",
    "SqlServers",
    "SqlServerVirtualMachines",
    "StorageAccounts",
    "VirtualMachines"
  ] : []


  privateLinkConnectionName    = "plconn${azurerm_log_analytics_workspace.loganalytics.name}${random_id.uniqueString.hex}"
  privateLinkEndpointName      = "pl${azurerm_log_analytics_workspace.loganalytics.name}${random_id.uniqueString.hex}"
  privateLinkScopeName         = "plscope${azurerm_log_analytics_workspace.loganalytics.name}${random_id.uniqueString.hex}"
  privateLinkScopeResourceName = "plscres${azurerm_log_analytics_workspace.loganalytics.name}${random_id.uniqueString.hex}"
}
