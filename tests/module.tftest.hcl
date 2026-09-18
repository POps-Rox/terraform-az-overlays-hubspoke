mock_provider "azurerm" {
  mock_data "azurerm_subscription" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000"
    }
  }

  mock_data "azurerm_resource_group" {
    defaults = {
      name     = "rg-existing"
      location = "eastus"
    }
  }

  mock_resource "azurerm_virtual_network" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub/providers/Microsoft.Network/virtualNetworks/vnet-hub"
    }
  }

  mock_resource "azurerm_subnet" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub/providers/Microsoft.Network/virtualNetworks/vnet-hub/subnets/snet-hub"
    }
  }

  mock_resource "azurerm_network_security_group" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub/providers/Microsoft.Network/networkSecurityGroups/nsg-hub"
    }
  }

  mock_resource "azurerm_route_table" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub/providers/Microsoft.Network/routeTables/rt-hub"
    }
  }

  mock_resource "azurerm_network_ddos_protection_plan" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub/providers/Microsoft.Network/ddosProtectionPlans/ddos-hub"
    }
  }

  mock_resource "azurerm_firewall_policy" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub/providers/Microsoft.Network/firewallPolicies/fw-policy-hub"
    }
  }

  mock_resource "azurerm_firewall" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub/providers/Microsoft.Network/azureFirewalls/fw-hub"
      ip_configuration = [{
        name                 = "fw-ipconfig"
        private_ip_address   = "10.0.2.4"
        public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub/providers/Microsoft.Network/publicIPAddresses/pip-fw"
        subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub/providers/Microsoft.Network/virtualNetworks/vnet-hub/subnets/AzureFirewallSubnet"
      }]
    }
  }

  mock_resource "azurerm_private_dns_zone" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub/providers/Microsoft.Network/privateDnsZones/mock.zone"
    }
  }
}

mock_provider "azapi" {}

mock_provider "popsrox" {
  mock_data "popsrox_resource_name" {
    defaults = {
      result = "generatedname"
    }
  }
}

override_module {
  target = module.mod_azregions
  outputs = {
    location_cli   = "eastus"
    location_short = "eus"
  }
}

override_module {
  target = module.mod_hub_rg
  outputs = {
    resource_group_name     = "rg-hub"
    resource_group_location = "eastus"
  }
}

variables {
  location = "eastus"
  firewall_config = {
    sku_name          = "AZFW_VNet"
    sku_tier          = "Standard"
    threat_intel_mode = "Alert"
    dns_servers       = ["10.0.0.4"]
    private_ip_ranges = ["IANAPrivateRanges"]
    zones             = []
  }
}

run "custom_names_tags_location_and_disabled_conditionals" {
  command = apply

  module {
    source = "./modules/virtual-network-hub"
  }

  variables {
    environment                   = "public"
    deploy_environment            = "qa"
    workload_name                 = "hub"
    hub_vnet_custom_name          = "vnet-custom"
    hub_snet_custom_name          = "snet-custom"
    hub_nsg_custom_name           = "nsg-custom"
    hub_sa_custom_name            = "sacustom001"
    hub_subnet_address_prefix     = ["10.0.0.0/24"]
    virtual_network_address_space = ["10.0.0.0/16"]
    enable_firewall               = false
    enable_forced_tunneling       = false
    enable_bastion_host           = false
    enable_resource_locks         = false
    create_ddos_plan              = false
    create_network_watcher        = false
    tags = {
      ResourceName = "caller-resource-name"
      env          = "caller-env"
      Owner        = "platform"
    }
  }

  assert {
    condition     = azurerm_virtual_network.hub_vnet.name == "vnet-custom"
    error_message = "hub_vnet_custom_name must override the generated VNet name."
  }

  assert {
    condition     = azurerm_virtual_network.hub_vnet.location == "eastus"
    error_message = "Hub VNet location must pass through the resolved module location."
  }

  assert {
    condition     = azurerm_virtual_network.hub_vnet.tags["ResourceName"] == "caller-resource-name" && azurerm_virtual_network.hub_vnet.tags["env"] == "caller-env" && azurerm_virtual_network.hub_vnet.tags["Owner"] == "platform"
    error_message = "Hub VNet tags must merge module tags with caller tags and allow caller tags to override."
  }

  assert {
    condition     = length(azurerm_firewall.fw) == 0 && length(azurerm_public_ip.firewall_client_pip) == 0 && length(azurerm_route.force_internet_tunneling) == 0 && length(azurerm_bastion_host.main) == 0
    error_message = "Firewall, forced tunneling, and bastion resources must not be planned when disabled."
  }

  assert {
    condition     = length(azurerm_management_lock.vnet_resource_group_level_lock) == 0 && length(azurerm_management_lock.subnet_resource_group_level_lock) == 0 && length(azurerm_management_lock.sa_resource_group_level_lock) == 0
    error_message = "Management locks must not be planned when enable_resource_locks is false."
  }
}

run "empty_string_names_fall_through" {
  command = apply

  module {
    source = "./modules/virtual-network-hub"
  }

  variables {
    environment                   = "public"
    workload_name                 = "hub"
    hub_vnet_custom_name          = ""
    hub_snet_custom_name          = ""
    hub_nsg_custom_name           = ""
    hub_sa_custom_name            = ""
    hub_subnet_address_prefix     = ["10.0.0.0/24"]
    virtual_network_address_space = ["10.0.0.0/16"]
    enable_firewall               = false
    enable_forced_tunneling       = false
    enable_bastion_host           = false
    enable_resource_locks         = false
    create_ddos_plan              = false
    create_network_watcher        = false
  }

  assert {
    condition     = azurerm_virtual_network.hub_vnet.name == "generatedname" && azurerm_subnet.default_snet.name == "generatedname" && azurerm_network_security_group.nsg.name == "generatedname" && azurerm_storage_account.storeacc.name == "generatedname"
    error_message = "Empty custom-name inputs must fall through to generated names."
  }
}

run "enabled_conditionals_service_endpoints_and_private_dns_ids" {
  command = plan

  module {
    source = "./modules/virtual-network-hub"
  }

  variables {
    environment                                   = "public"
    workload_name                                 = "hub"
    hub_subnet_address_prefix                     = ["10.0.0.0/24"]
    hub_subnet_service_endpoints                  = ["Microsoft.Storage"]
    hub_private_endpoint_network_policies_enabled = true
    virtual_network_address_space                 = ["10.0.0.0/16"]
    enable_firewall                               = true
    enable_forced_tunneling                       = true
    fw_client_snet_address_prefix                 = ["10.0.1.0/26"]
    fw_client_snet_service_endpoints              = ["Microsoft.KeyVault"]
    fw_management_snet_address_prefix             = ["10.0.2.0/26"]
    fw_management_snet_service_endpoints          = ["Microsoft.Storage"]
    enable_bastion_host                           = true
    azure_bastion_subnet_address_prefix           = ["10.0.3.0/27"]
    enable_resource_locks                         = true
    lock_level                                    = "CanNotDelete"
    create_ddos_plan                              = true
    ddos_plan_name                                = "ddos-hub"
    create_network_watcher                        = true
  }

  assert {
    condition     = length(azurerm_firewall.fw) == 1 && length(azurerm_public_ip.firewall_client_pip) == 1 && length(azurerm_public_ip.firewall_management_pip) == 1 && length(azurerm_route.force_internet_tunneling) == 1
    error_message = "Firewall and forced-tunneling resources must be planned when enabled."
  }

  assert {
    condition     = length(azurerm_bastion_host.main) == 1 && length(azurerm_subnet.abs_snet) == 1 && length(azurerm_management_lock.vnet_resource_group_level_lock) == 1 && length(azurerm_management_lock.sa_resource_group_level_lock) == 1
    error_message = "Bastion and management lock resources must be planned when enabled."
  }

  assert {
    condition     = azurerm_subnet.default_snet.service_endpoint[0].service == "Microsoft.Storage" && azurerm_subnet.default_snet.private_endpoint_network_policies == "Enabled"
    error_message = "Subnet service_endpoints input must map to service_endpoint blocks and preserve private endpoint policy intent."
  }

  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.privatelink_monitor_azure_com_privatelink_monitor_azure_com_link.private_dns_zone_id == azurerm_private_dns_zone.privatelink_monitor_azure_com.id && azurerm_private_dns_zone_virtual_network_link.privateDnsZones_privatelink_blob_core_cloudapi_net_privateDnsZones_privatelink_blob_core_cloudapi_net_link.private_dns_zone_id == azurerm_private_dns_zone.privatelink_blob_core_cloudapi_net.id
    error_message = "Private DNS zone virtual network links must use private_dns_zone_id from the zone ID."
  }
}
