# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


##########################
# RG Configuration    ##
##########################

variable "custom_hub_resource_group_name" {
  description = "The name of the resource group to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

#################################
# Hub Configuration
#################################

variable "hub_custom_name" {
  description = "Custom name to use for the Hub deployment. If not specified, the default naming (hub-core) will be used. This value will be used as a hub prefix for all resources created by this module."
  type        = string
  default     = null
}

variable "hub_subscription_id" {
  description = "Subscription ID for the Hub deployment"
  type        = string
  default     = null

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.hub_subscription_id)) || var.hub_subscription_id == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "hub_vnet_address_space" {
  description = "The CIDR Virtual Network Address Prefix for the Hub Virtual Network."
  type        = list(string)
  default     = []
}

variable "create_ddos_plan" {
  type        = bool
  description = "Create an ddos plan - Default is false"
  default     = false
}

variable "ddos_plan_name" {
  type        = any
  description = "The name of AzureNetwork DDoS Protection Plan"
  default     = null
}

variable "create_network_watcher" {
  type        = bool
  description = "Controls if Network Watcher resources should be created for the Azure subscription"
  default     = false
}

#################################
# Hub Subnet Configuration
#################################

variable "hub_subnet_address_prefix" {
  description = "The CIDR Address Prefixes for the Subnets in the Hub Virtual Network."
  type        = list(string)
  default     = []
}

variable "hub_subnet_service_endpoints" {
  description = "The CIDR Address Prefixes for the Subnets in the Hub Virtual Network."
  type        = list(string)
  default     = []
}

variable "hub_private_endpoint_network_policies_enabled" {
  type        = any
  description = "Whether or not to enable network policies on the private endpoint subnet"
  default     = null
}

variable "hub_private_endpoint_service_endpoints_enabled" {
  type        = any
  description = "Whether or not to enable service endpoints on the private endpoint subnet"
  default     = null
}

variable "hub_add_subnets" {
  description = "A list of subnets to add to the hub"
  type = map(object({
    name                                       = string
    address_prefixes                           = list(string)
    service_endpoints                          = list(string)
    private_endpoint_network_policies_enabled  = bool
    private_endpoint_service_endpoints_enabled = bool
  }))
  default = {}
}

variable "gateway_subnet_address_prefix" {
  type        = any
  description = "The address prefix to use for the gateway subnet"
  default     = null
}

variable "gateway_service_endpoints" {
  description = "Service endpoints to add to the Gateway subnet"
  type        = list(string)
  default     = []
}

variable "dns_servers" {
  type        = any
  description = "List of dns servers to use for virtual network"
  default     = []
}

##############################
# Firewall Configuration    ##
##############################

variable "enable_firewall" {
  type        = any
  description = "Controls if Azure Firewall resources should be created for the Azure subscription"
}

variable "enable_forced_tunneling" {
  type        = any
  description = "Route all Internet-bound traffic to a designated next hop instead of going directly to the Internet"
}

variable "fw_client_snet_address_prefix" {
  type        = any
  description = "The address prefix to use for the Firewall subnet"
  default     = null
}

variable "fw_management_snet_address_prefix" {
  type        = any
  description = "The address prefix to use for Firewall managemement subnet to enable forced tunnelling. The Management Subnet used for the Firewall must have the name `AzureFirewallManagementSubnet` and the subnet mask must be at least a `/26`."
  default     = null
}

variable "fw_client_snet_service_endpoints" {
  description = "Service endpoints to add to the firewall client subnet"
  type        = list(string)
  default     = []
}

variable "fw_client_snet_private_endpoint_network_policies_enabled" {
  description = "Controls if network policies are enabled on the firewall client subnet"
  type        = bool
  default     = false
}

variable "fw_client_snet_private_link_service_network_policies_enabled" {
  description = "Controls if private link service network policies are enabled on the firewall client subnet"
  type        = bool
  default     = false
}

variable "fw_management_snet_service_endpoints" {
  description = "Service endpoints to add to the firewall management subnet"
  type        = list(string)
  default     = []
}

variable "fw_management_snet_private_endpoint_network_policies_enabled" {
  description = "Controls if network policies are enabled on the firewall management subnet"
  type        = bool
  default     = false
}

variable "fw_management_snet_private_link_service_network_policies_enabled" {
  description = "Controls if private link service network policies are enabled on the firewall management subnet"
  type        = bool
  default     = false
}

variable "fw_sku" {
  type        = any
  description = "The SKU of the Azure Firewall"
  default     = null
}

variable "fw_tier" {
  type        = any
  description = "The Tier of the Azure Firewall"
  default     = null
}

variable "fw_zones" {
  description = "The zones of the Azure Firewall"
  type        = list(string)
  default     = null
}

variable "fw_private_ip_ranges" {
  description = "The private IP ranges of the Azure Firewall"
  type        = list(string)
  default     = null
}

variable "fw_dns_servers" {
  description = "The DNS servers of the Azure Firewall"
  type        = list(string)
  default     = null
}

variable "fw_intrusion_detection_mode" {
  type        = string
  description = "Controls if Azure Firewall Intrusion Detection System (IDS) should be enabled for the Azure subscription"
  default     = "Alert"

  validation {
    condition     = contains(["Alert", "Deny", "Off"], var.fw_intrusion_detection_mode)
    error_message = "The Intrusion Detection Mode must be either 'Alert' or 'Deny' or 'Off'. The default value is 'Alert'."
  }
}

variable "fw_threat_intelligence_mode" {
  type        = string
  description = "Controls if Azure Firewall Threat Intelligence should be enabled for the Azure subscription"
  default     = "Alert"

  validation {
    condition     = contains(["Alert", "Deny", "Off"], var.fw_threat_intelligence_mode)
    error_message = "The Threat Intelligence Mode must be either 'Alert' or 'Deny' or 'Off'. The default value is 'Alert'."
  }
}

variable "base_policy_id" {
  type        = any
  description = "The ID of the base policy to use for the Azure Firewall. This is used to create a new policy based on the base policy."
  default     = null
}

variable "virtual_hub" {
  description = "An Azure Virtual WAN Hub with associated security and routing policies configured by Azure Firewall Manager. Use secured virtual hubs to easily create hub-and-spoke and transitive architectures with native security services for traffic governance and protection."
  type = object({
    virtual_hub_id  = string
    public_ip_count = number
  })
  default = null
}

variable "fw_application_rules" {
  description = "List of application rules to apply to firewall."
  type = list(object({
    name             = string
    description      = optional(string)
    action           = string
    source_addresses = optional(list(string))
    source_ip_groups = optional(list(string))
    fqdn_tags        = optional(list(string))
    target_fqdns     = optional(list(string))
    protocol = optional(object({
      type = string
      port = string
    }))
  }))
  default = []
}

variable "fw_network_rules" {
  description = "List of network rules to apply to firewall."
  type = list(object({
    name                  = string
    description           = optional(string)
    action                = string
    source_addresses      = optional(list(string))
    destination_ports     = list(string)
    destination_addresses = optional(list(string))
    destination_fqdns     = optional(list(string))
    protocols             = list(string)
  }))
  default = []
}

variable "fw_nat_rules" {
  description = "List of nat rules to apply to firewall."
  type = list(object({
    name                  = string
    description           = optional(string)
    action                = string
    source_addresses      = optional(list(string))
    destination_ports     = list(string)
    destination_addresses = list(string)
    protocols             = list(string)
    translated_address    = string
    translated_port       = string
  }))
  default = []
}

#####################################
# Firewall Policy Configuration    ##
#####################################
variable "fw_policy_application_rule_collection" {
  default     = {}
  description = <<EOD
    application_rule_collection = [
        {
            name     = "default_app_rules"
            priority = 500
            action   = "Allow"
            rules = [
                {
                    name              = "default_app_rules_rule1"
                    source_addresses  = ["10.0.0.0/24"]
                    destination_fqdns = ["www.google.co.uk"]
                    protocols         = [
                        {
                            type = "http"
                            port = 80
                        },
                        {
                            type = "https"
                            port = 443
                        }
                    ]
                },
                {
                    name                  = "default_app_rules_rule2"
                    source_addresses      = ["10.0.0.0/24"]
                    destination_fqdn_tags = ["Windows Update"]
                    protocols             = [
                        {
                            type = "https"
                            port = 443
                        },
                        {
                            type = "http"
                            port = 80
                        },
                    ]
                }
            ]
        },
        {
            name     = "ASE_app_rules"
            priority = 600
            action   = "Allow"
            rules = [
                {
                    name                  = "ASE_app_rules_rule1"
                    source_addresses      = ["10.0.0.0/24"]
                    destination_fqdn_tags = ["App Service Environment (ASE)"]
                    protocols             = [
                        {
                            type = "https"
                            port = 443
                        }
                    ]
                }
            ]
        }
    ]
EOD
}


variable "fw_policy_network_rule_collection" {
  type = any
  default = [
    {
      name     = "AllowAzureCloud"
      priority = "100"
      action   = "Allow"
      rules = [
        {
          name                  = "AzureCloud"
          protocols             = ["Any"]
          source_addresses      = ["*"]
          destination_addresses = ["AzureCloud"]
          destination_ports     = ["*"]
        }
      ]
    },
    {
      name     = "AllowTrafficBetweenSpokes"
      priority = "200"
      action   = "Allow"
      rules = [
        {
          name                  = "AllSpokeTraffic"
          protocols             = ["Any"]
          source_addresses      = ["10.96.0.0/19"]
          destination_addresses = ["*"]
          destination_ports     = ["*"]
        }
      ]
    }
  ]
  description = <<EOD
    network_rule_collections = [
        {
            name = "default_network_rules"
            priority = "500"
            action = "Allow"
            rules = [
                {
                    name                  = "default_network_rules_AllowRDP" 
                    protocols             = ["TCP"]
                    source_addresses      = ["10.0.0.1"]
                    destination_addresses = ["192.168.0.21"]
                    destination_ports     = ["3389"]
                },
                {
                    name                  = "default_network_rules_AllowSSH" 
                    protocols             = ["TCP"]
                    source_addresses      = ["10.0.0.1"]
                    destination_addresses = ["192.168.0.22"]
                    destination_ports     = ["22"]
                }
            ]
        }
    ]
EOD
}

variable "fw_policy_nat_rule_collections" {
  type        = any
  default     = {}
  description = <<EOD
    name     = nat_rule_collection1
    priority = "300"
    action   = "Dnat"     # Only 'Dnat' is possible
    rules    = [
        {
            name                = "nat_rule_collection1_rule1"
            protocols           = ["TCP"]
            source_addresses    = ["10.0.0.1", "10.0.0.2"]
            destination_address = "192.168.1.1"
            destination_ports   = ["80"]
            translated_address  = "192.168.0.1"
            translated_port     = "8080"
        }
    ]
EOD
}

##################################
# Firewall PIP Configuration    ##
##################################

variable "fw_pip_sku" {
  description = "The SKU of the public IP address"
  type        = string
  default     = "Standard"
}

variable "fw_pip_allocation_method" {
  description = "The allocation method of the public IP address"
  type        = string
  default     = "Static"
}

#########################
# NSG Configuration    ##
#########################

variable "hub_deny_all_inbound" {
  description = "True to deny all inbound traffic by default"
  type        = bool
  default     = true
}

variable "hub_http_inbound_allowed" {
  description = "True to allow inbound HTTP traffic"
  type        = bool
  default     = false
}

variable "hub_allowed_http_source" {
  description = "Allowed source for inbound HTTP traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.hub_allowed_http_source != null &&
      var.hub_allowed_http_source != "" &&
      (can(tolist(var.hub_allowed_http_source)) || can(tostring(var.hub_allowed_http_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "hub_https_inbound_allowed" {
  description = "True to allow inbound HTTPS traffic"
  type        = bool
  default     = false
}

variable "hub_allowed_https_source" {
  description = "Allowed source for inbound HTTPS traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.hub_allowed_https_source != null &&
      var.hub_allowed_https_source != "" &&
      (can(tolist(var.hub_allowed_https_source)) || can(tostring(var.hub_allowed_https_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "hub_ssh_inbound_allowed" {
  description = "True to allow inbound SSH traffic"
  type        = bool
  default     = false
}

variable "hub_allowed_ssh_source" {
  description = "Allowed source for inbound SSH traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.hub_allowed_ssh_source != null &&
      var.hub_allowed_ssh_source != "" &&
      (can(tolist(var.hub_allowed_ssh_source)) || can(tostring(var.hub_allowed_ssh_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "hub_rdp_inbound_allowed" {
  description = "True to allow inbound RDP traffic"
  type        = bool
  default     = false
}

variable "hub_allowed_rdp_source" {
  description = "Allowed source for inbound RDP traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.hub_allowed_rdp_source != null &&
      var.hub_allowed_rdp_source != "" &&
      (can(tolist(var.hub_allowed_rdp_source)) || can(tostring(var.hub_allowed_rdp_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "hub_winrm_inbound_allowed" {
  description = "True to allow inbound WinRM traffic"
  type        = bool
  default     = false
}

variable "hub_allowed_winrm_source" {
  description = "Allowed source for inbound WinRM traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.hub_allowed_winrm_source != null &&
      var.hub_allowed_winrm_source != "" &&
      (can(tolist(var.hub_allowed_winrm_source)) || can(tostring(var.hub_allowed_winrm_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "hub_application_gateway_rules_enabled" {
  description = "True to configure rules mandatory for hosting an Application Gateway. See https://docs.microsoft.com/en-us/azure/application-gateway/configuration-infrastructure#allow-access-to-a-few-source-ips"
  type        = bool
  default     = false
}

variable "hub_load_balancer_rules_enabled" {
  description = "True to configure rules mandatory for hosting a Load Balancer."
  type        = bool
  default     = false
}

variable "hub_nsg_additional_rules" {
  description = "Additional network security group rules to add. For arguements please refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule#argument-reference"
  type = list(object({
    priority  = number
    name      = string
    direction = optional(string, "Inbound")
    access    = optional(string, "Allow")
    protocol  = optional(string, "Tcp")

    source_port_range  = optional(string)
    source_port_ranges = optional(list(string))

    destination_port_range  = optional(string)
    destination_port_ranges = optional(list(string))

    source_address_prefix   = optional(string)
    source_address_prefixes = optional(list(string))

    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
  default = []
}

variable "hub_nfs_inbound_allowed" {
  description = "True to allow inbound NFSv4 traffic"
  type        = bool
  default     = false
}

variable "hub_allowed_nfs_source" {
  description = "Allowed source for inbound NFSv4 traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.hub_allowed_nfs_source != null &&
      var.hub_allowed_nfs_source != "" &&
      (can(tolist(var.hub_allowed_nfs_source)) || can(tostring(var.hub_allowed_nfs_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "hub_cifs_inbound_allowed" {
  description = "True to allow inbound CIFS traffic"
  type        = bool
  default     = false
}

variable "hub_allowed_cifs_source" {
  description = "Allowed source for inbound CIFS traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.hub_allowed_cifs_source != null &&
      var.hub_allowed_cifs_source != "" &&
      (can(tolist(var.hub_allowed_cifs_source)) || can(tostring(var.hub_allowed_cifs_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

##################################
# Defender Configuration        ##
##################################

variable "security_center_subscription_pricing" {
  type        = string
  description = "The pricing tier to use. Possible values are Free and Standard"
  default     = "Standard"
}

variable "security_center_contacts" {
  type        = map(string)
  description = "Manages the subscription's Security Center Contact"
  default     = {}
}

variable "scope_resource_id" {
  type        = any
  description = "The scope of VMs to send their security data to the desired workspace, unless overridden by a setting with more specific scope"
  default     = null
}

variable "security_center_setting_name" {
  type        = string
  description = "The setting to manage. Possible values are `MCAS` and `WDAT`"
  default     = "MCAS"
}

variable "enable_security_center_setting" {
  type        = bool
  description = "Boolean flag to enable/disable data access"
  default     = false
}

variable "enable_security_center_auto_provisioning" {
  type        = string
  description = "Should the security agent be automatically provisioned on Virtual Machines in this subscription?"
  default     = "Off"
}
