# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module Example to deploy an SCCA Compliant Operations Virtual Network
DESCRIPTION: The following components will be options in this deployment
            * Operations Virtual Network (VNet)              
AUTHOR/S: jspinella
*/

#################################
### Ops Logging Configuration ###
#################################
module "mod_ops_logging" {
  providers = { azurerm = azurerm.ops }
  source    = "./modules/operational-logging"

  // Global Settings
  environment                        = var.environment
  location                           = var.location
  deploy_environment                 = var.deploy_environment
  org_name                           = var.org_name
  workload_name                      = try(trimspace(var.ops_logging_name) != "", false) ? var.ops_logging_name : "ops-logging-core"
  custom_logging_resource_group_name = try(trimspace(var.custom_logging_resource_group_name) != "", false) ? var.custom_logging_resource_group_name : null

  # (Required) Enable Azure Sentinel
  enable_sentinel = var.enable_sentinel

  # (Required) Private Endpoint Network Subnet ID
  private_endpoint_subnet_id = module.mod_ops_network.default_subnet_id

  # (Required) To enable Azure Monitoring
  # Sku Name - Possible values are PerGB2018 and Free
  # Log Retention in days - Possible values range between 30 and 730
  log_analytics_workspace_sku          = var.log_analytics_workspace_sku
  log_analytics_logs_retention_in_days = var.log_analytics_logs_retention_in_days

  // Defender Settings
  enable_security_center_setting           = var.enable_security_center_setting
  enable_security_center_auto_provisioning = var.enable_security_center_auto_provisioning
  scope_resource_id                        = var.scope_resource_id
  security_center_subscription_pricing     = var.security_center_subscription_pricing
  security_center_contacts                 = var.security_center_contacts

  # Locks
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Tags
  add_tags = var.tags # Tags to be applied to all resources

}

#######################################
### Ops Spoke Network Configuration ###
#######################################
module "mod_ops_network" {
  providers = { azurerm = azurerm.ops, azurerm.hub_network = azurerm.hub }
  source    = "./modules/virtual-network-spoke"

  // Global Settings
  environment                = var.environment
  location                   = var.location
  deploy_environment         = var.deploy_environment
  org_name                   = var.org_name
  workload_name              = try(trimspace(var.ops_spoke_name) != "", false) ? var.ops_spoke_name : "ops-core"
  custom_resource_group_name = try(trimspace(var.custom_ops_resource_group_name) != "", false) ? var.custom_ops_resource_group_name : null

  # Specify if you are deploying the spoke VNet using the same hub Azure subscription
  is_spoke_deployed_to_same_hub_subscription = var.is_ops_deployed_to_same_hub_subscription

  # Spoke Virtual Network Parameters  
  spoke_vnet_custom_name        = var.custom_ops_vnet_name
  virtual_network_address_space = var.ops_virtual_network_address_space

  // Spoke Default Subnet   
  # Provide valid subnet address prefix for spoke virtual network.
  spoke_subnet_address_prefix                         = var.ops_subnet_address_prefix
  spoke_subnet_service_endpoints                      = var.ops_subnet_service_endpoints
  spoke_private_endpoint_network_policies_enabled     = var.ops_subnet_private_endpoint_network_policies_enabled
  spoke_private_link_service_network_policies_enabled = var.ops_subnet_private_link_service_network_policies_enabled

  // Spoke Additional Subnets.
  add_subnets = var.ops_additional_subnets

  # Spoke Network Security Group rules
  deny_all_inbound                  = var.ops_deny_all_inbound
  http_inbound_allowed              = var.ops_http_inbound_allowed
  https_inbound_allowed             = var.ops_https_inbound_allowed
  ssh_inbound_allowed               = var.ops_ssh_inbound_allowed
  rdp_inbound_allowed               = var.ops_rdp_inbound_allowed
  winrm_inbound_allowed             = var.ops_winrm_inbound_allowed
  application_gateway_rules_enabled = var.ops_application_gateway_rules_enabled
  nfs_inbound_allowed               = var.ops_nfs_inbound_allowed
  cifs_inbound_allowed              = var.ops_cifs_inbound_allowed

  # Spoke Network Security Group additional rules
  nsg_additional_rules = var.ops_nsg_additional_rules

  # Spoke network details to create peering and other setup
  hub_virtual_network_id          = module.mod_hub_network.hub_virtual_network_id
  hub_firewall_private_ip_address = module.mod_hub_network.firewall_private_ip
  allow_forwarded_spoke_traffic   = var.allow_ops_forwarded_traffic
  allow_gateway_spoke_transit     = var.allow_ops_gateway_transit
  use_remote_spoke_gateway        = var.allow_ops_virtual_network_access

  # Locks
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Tags
  add_tags = var.tags # Tags to be applied to all resources
}
