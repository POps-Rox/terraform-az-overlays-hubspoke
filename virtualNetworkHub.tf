# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module Example to deploy an SCCA Compliant Hub Virtual Network
DESCRIPTION: The following components will be options in this deployment
            * Hub Virtual Network (VNet)              
            * Azure Firewall
AUTHOR/S: jspinella
*/

##################################
### Hub Network Configuration  ###
##################################
module "mod_hub_network" {
  providers = { azurerm = azurerm.hub }
  depends_on = [
    module.mod_ops_logging
  ]
  source = "./modules/virtual-network-hub"

  // Global Settings
  environment                = var.environment
  location                   = var.location
  deploy_environment         = var.deploy_environment
  org_name                   = var.org_name
  workload_name              = try(trimspace(var.hub_custom_name) != "", false) ? var.hub_custom_name : "hub-core"
  custom_resource_group_name = try(trimspace(var.custom_hub_resource_group_name) != "", false) ? var.custom_hub_resource_group_name : null

  // Hub Virtual Network Parameters  
  virtual_network_address_space = var.hub_vnet_address_space

  # Create DDOS Plan. Default is false
  create_ddos_plan = var.create_ddos_plan

  # Create Network Watcher. Default is false
  create_network_watcher = var.create_network_watcher

  // Hub Default Subnet  
  hub_subnet_address_prefix                         = var.hub_subnet_address_prefix
  hub_subnet_service_endpoints                      = var.hub_subnet_service_endpoints
  hub_private_endpoint_network_policies_enabled     = var.hub_private_endpoint_network_policies_enabled
  hub_private_link_service_network_policies_enabled = var.hub_private_endpoint_service_endpoints_enabled

  // Hub Additional Subnets.
  add_subnets = var.hub_add_subnets

  // Hub Network Security Group
  deny_all_inbound                  = var.hub_deny_all_inbound
  http_inbound_allowed              = var.hub_http_inbound_allowed
  https_inbound_allowed             = var.hub_https_inbound_allowed
  ssh_inbound_allowed               = var.hub_ssh_inbound_allowed
  rdp_inbound_allowed               = var.hub_rdp_inbound_allowed
  winrm_inbound_allowed             = var.hub_winrm_inbound_allowed
  application_gateway_rules_enabled = var.hub_application_gateway_rules_enabled
  nfs_inbound_allowed               = var.hub_nfs_inbound_allowed
  cifs_inbound_allowed              = var.hub_cifs_inbound_allowed

  // Firewall Settings
  enable_firewall         = var.enable_firewall
  enable_forced_tunneling = var.enable_forced_tunneling

  // Firewall Subnets
  fw_client_snet_address_prefix        = var.fw_client_snet_address_prefix
  fw_management_snet_address_prefix    = var.fw_management_snet_address_prefix
  fw_client_snet_service_endpoints     = var.fw_client_snet_service_endpoints
  fw_management_snet_service_endpoints = var.fw_management_snet_service_endpoints

  # Firewall Config
  firewall_config = {
    sku_name          = var.fw_sku
    sku_tier          = var.fw_tier
    threat_intel_mode = var.fw_threat_intelligence_mode
    dns_servers       = var.fw_dns_servers
    private_ip_ranges = var.fw_private_ip_ranges
    zones             = var.fw_zones
  }

  // Firewall Rules  
  fw_network_rules     = var.fw_network_rules
  fw_application_rules = var.fw_application_rules
  fw_nat_rules         = var.fw_nat_rules

  # Firewall Policy Rules
  application_rule_collection = var.fw_policy_application_rule_collection
  nat_rule_collections        = var.fw_policy_nat_rule_collections
  network_rule_collection     = var.fw_policy_network_rule_collection

  # Gateway Subnet
  gateway_subnet_address_prefix = var.gateway_subnet_address_prefix
  gateway_service_endpoints     = var.gateway_service_endpoints

  // Bastion Host
  enable_bastion_host                       = var.enable_bastion_host
  azure_bastion_host_sku                    = var.azure_bastion_host_sku
  azure_bastion_public_ip_allocation_method = var.azure_bastion_public_ip_allocation_method
  azure_bastion_subnet_address_prefix       = var.azure_bastion_subnet_address_prefix

  // Bastion Components
  enable_copy_paste     = var.enable_copy_paste
  enable_file_copy      = var.enable_file_copy
  enable_ip_connect     = var.enable_ip_connect
  scale_units           = var.scale_units
  enable_shareable_link = var.enable_shareable_link
  enable_tunneling      = var.enable_tunneling

  // Locks
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  // Tags
  add_tags = var.tags # Tags to be applied to all resources
}
