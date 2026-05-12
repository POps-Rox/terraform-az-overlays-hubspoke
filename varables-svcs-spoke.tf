# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


########################
# RG Configuration    ##
########################

variable "custom_svcs_resource_group_name" {
  description = "The name of the resource group to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

#############################################
# Shared Services Spoke Configuration     ###
#############################################

variable "enable_shared_services_spoke" {
  description = "Enable Shared Services Spoke deployment"
  type        = bool
  default     = true
}

variable "svcs_spoke_name" {
  description = "A name for the svcs spoke. It defaults to svcs-core."
  type        = string
  default     = "svcs-core"
}

variable "svcs_subscription_id" {
  description = "Subscription ID for the Hub deployment"
  type        = string
  default     = null

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.svcs_subscription_id)) || var.svcs_subscription_id == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "is_svcs_deployed_to_same_hub_subscription" {
  type        = bool
  description = "Indicates if the svcs is deployed to the same subscription as the hub. Default is true."
  default     = true
}

##########################
# VNet Configuration    ##
##########################

variable "custom_svcs_vnet_name" {
  type        = any
  description = "(Optional) Specifies the custom name of the vnet for the svcs vnet. If not specified, the default naming is used"
  default     = null
}

variable "svcs_virtual_network_address_space" {
  type        = any
  description = "The address space to be used for the Azure virtual network."
  default     = []
}

##########################
# Subnet Configuration  ##
##########################

variable "svcs_subnet_address_prefix" {
  type        = any
  description = "The address prefix to use for the subnet"
  default     = null
}

variable "svcs_subnet_service_endpoints" {
  type        = any
  description = "Service endpoints to add to the subnet"
  default     = null
}

variable "svcs_subnet_private_endpoint_network_policies_enabled" {
  type        = any
  description = "Enable or disable private endpoint network policies on the subnet"
  default     = null
}

variable "svcs_subnet_private_link_service_network_policies_enabled" {
  type        = any
  description = "Enable or disable private link service network policies on the subnet"
  default     = null
}

variable "svcs_additional_subnets" {
  description = "A list of subnets to add to the svcs vnet"
  type = map(object({
    name                                       = string
    address_prefixes                           = list(string)
    service_endpoints                          = list(string)
    private_endpoint_network_policies_enabled  = bool
    private_endpoint_service_endpoints_enabled = bool
  }))
  default = {}
}

##############################
# Routetable Configuration  ##
##############################

variable "svcs_routetable_custom_name" {
  type        = any
  description = "(Optional) Specifies the custom name of the route table. If not specified, the default naming is used"
  default     = null
}

variable "svcs_route_table_routes" {
  description = "A map of route table routes to add to the route table"
  type = map(object({
    name                          = string
    address_prefix                = string
    next_hop_type                 = string
    next_hop_in_ip_address        = string
    disable_bgp_route_propagation = bool
  }))
  default = {}
}

#########################
# NSG Configuration    ##
#########################

variable "svcs_deny_all_inbound" {
  description = "True to deny all inbound traffic by default"
  type        = bool
  default     = true
}

variable "svcs_http_inbound_allowed" {
  description = "True to allow inbound HTTP traffic"
  type        = bool
  default     = false
}

variable "svcs_allowed_http_source" {
  description = "Allowed source for inbound HTTP traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.svcs_allowed_http_source != null &&
      var.svcs_allowed_http_source != "" &&
      (can(tolist(var.svcs_allowed_http_source)) || can(tostring(var.svcs_allowed_http_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "svcs_https_inbound_allowed" {
  description = "True to allow inbound HTTPS traffic"
  type        = bool
  default     = false
}

variable "svcs_allowed_https_source" {
  description = "Allowed source for inbound HTTPS traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.svcs_allowed_https_source != null &&
      var.svcs_allowed_https_source != "" &&
      (can(tolist(var.svcs_allowed_https_source)) || can(tostring(var.svcs_allowed_https_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "svcs_ssh_inbound_allowed" {
  description = "True to allow inbound SSH traffic"
  type        = bool
  default     = false
}

variable "svcs_allowed_ssh_source" {
  description = "Allowed source for inbound SSH traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.svcs_allowed_ssh_source != null &&
      var.svcs_allowed_ssh_source != "" &&
      (can(tolist(var.svcs_allowed_ssh_source)) || can(tostring(var.svcs_allowed_ssh_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "svcs_rdp_inbound_allowed" {
  description = "True to allow inbound RDP traffic"
  type        = bool
  default     = false
}

variable "svcs_allowed_rdp_source" {
  description = "Allowed source for inbound RDP traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.svcs_allowed_rdp_source != null &&
      var.svcs_allowed_rdp_source != "" &&
      (can(tolist(var.svcs_allowed_rdp_source)) || can(tostring(var.svcs_allowed_rdp_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "svcs_winrm_inbound_allowed" {
  description = "True to allow inbound WinRM traffic"
  type        = bool
  default     = false
}

variable "svcs_allowed_winrm_source" {
  description = "Allowed source for inbound WinRM traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.svcs_allowed_winrm_source != null &&
      var.svcs_allowed_winrm_source != "" &&
      (can(tolist(var.svcs_allowed_winrm_source)) || can(tostring(var.svcs_allowed_winrm_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "svcs_application_gateway_rules_enabled" {
  description = "True to configure rules mandatory for hosting an Application Gateway. See https://docs.microsoft.com/en-us/azure/application-gateway/configuration-infrastructure#allow-access-to-a-few-source-ips"
  type        = bool
  default     = false
}

variable "svcs_load_balancer_rules_enabled" {
  description = "True to configure rules mandatory for hosting a Load Balancer."
  type        = bool
  default     = false
}

variable "svcs_nsg_additional_rules" {
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

variable "svcs_nfs_inbound_allowed" {
  description = "True to allow inbound NFSv4 traffic"
  type        = bool
  default     = false
}

variable "svcs_allowed_nfs_source" {
  description = "Allowed source for inbound NFSv4 traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.svcs_allowed_nfs_source != null &&
      var.svcs_allowed_nfs_source != "" &&
      (can(tolist(var.svcs_allowed_nfs_source)) || can(tostring(var.svcs_allowed_nfs_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "svcs_cifs_inbound_allowed" {
  description = "True to allow inbound CIFS traffic"
  type        = bool
  default     = false
}

variable "svcs_allowed_cifs_source" {
  description = "Allowed source for inbound CIFS traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.svcs_allowed_cifs_source != null &&
      var.svcs_allowed_cifs_source != "" &&
      (can(tolist(var.svcs_allowed_cifs_source)) || can(tostring(var.svcs_allowed_cifs_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

##################################
# VNet Peering Configuration    ##
##################################1

variable "allow_svcs_forwarded_traffic" {
  description = "True to allow forwarded traffic"
  type        = bool
  default     = false
}

variable "allow_svcs_gateway_transit" {
  description = "True to allow gateway transit"
  type        = bool
  default     = false
}

variable "allow_svcs_virtual_network_access" {
  description = "True to use remote gateways"
  type        = bool
  default     = false
}


