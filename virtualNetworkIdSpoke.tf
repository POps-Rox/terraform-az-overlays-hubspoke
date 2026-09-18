# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module Example to deploy an SCCA Compliant Identity Virtual Network
DESCRIPTION: The following components will be options in this deployment
            * Identity Virtual Network (VNet)              
AUTHOR/S: jspinella
*/

###################################################
### Identity Spoke Network Configuration ###
###################################################1
module "mod_id_network" {
  providers = { azurerm = azurerm.id, azurerm.hub_network = azurerm.hub }
  depends_on = [
    module.mod_hub_network,
    module.mod_ops_network,
    module.mod_ops_logging
  ]
  source = "./modules/virtual-network-spoke"

  count = var.enable_identity_spoke ? 1 : 0

  // Global Settings
  environment                = var.environment
  location                   = var.location
  deploy_environment         = var.deploy_environment
  org_name                   = var.org_name
  workload_name              = try(trimspace(var.id_spoke_name) != "", false) ? var.id_spoke_name : "id-core"
  custom_resource_group_name = try(trimspace(var.custom_id_resource_group_name) != "", false) ? var.custom_id_resource_group_name : null

  # Specify if you are deploying the spoke VNet using the same hub Azure subscription
  is_spoke_deployed_to_same_hub_subscription = var.is_id_deployed_to_same_hub_subscription

  # Spoke Virtual Network Parameters  
  spoke_vnet_custom_name        = var.custom_id_vnet_name
  virtual_network_address_space = var.id_virtual_network_address_space

  // Spoke Default Subnet   
  # Provide valid subnet address prefix for spoke virtual network.
  spoke_subnet_address_prefix                         = var.id_subnet_address_prefix
  spoke_subnet_service_endpoints                      = var.id_subnet_service_endpoints
  spoke_private_endpoint_network_policies_enabled     = var.id_subnet_private_endpoint_network_policies_enabled
  spoke_private_link_service_network_policies_enabled = var.id_subnet_private_link_service_network_policies_enabled

  // Spoke Additional Subnets.
  add_subnets = var.id_additional_subnets

  # Spoke Network Security Group rules
  deny_all_inbound                  = var.id_deny_all_inbound
  http_inbound_allowed              = var.id_http_inbound_allowed
  https_inbound_allowed             = var.id_https_inbound_allowed
  ssh_inbound_allowed               = var.id_ssh_inbound_allowed
  rdp_inbound_allowed               = var.id_rdp_inbound_allowed
  winrm_inbound_allowed             = var.id_winrm_inbound_allowed
  application_gateway_rules_enabled = var.id_application_gateway_rules_enabled
  nfs_inbound_allowed               = var.id_nfs_inbound_allowed
  cifs_inbound_allowed              = var.id_cifs_inbound_allowed

  # Spoke Network Security Group additional rules
  nsg_additional_rules = var.id_nsg_additional_rules

  # Spoke network details to create peering and other setup
  hub_virtual_network_id          = module.mod_hub_network.hub_virtual_network_id
  hub_firewall_private_ip_address = module.mod_hub_network.firewall_private_ip
  allow_forwarded_spoke_traffic   = var.allow_id_forwarded_traffic
  allow_gateway_spoke_transit     = var.allow_id_gateway_transit
  use_remote_spoke_gateway        = var.allow_id_virtual_network_access

  # Locks
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Tags
  add_tags = var.tags # Tags to be applied to all resources
}
