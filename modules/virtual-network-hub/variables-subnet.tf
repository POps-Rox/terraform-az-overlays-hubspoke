# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

############################
# Subnet Configuration    ##
############################

variable "hub_subnet_address_prefix" {
  description = "The address prefixes to use for the default subnet"
  type        = list(string)
  default     = []
}

variable "hub_subnet_service_endpoints" {
  description = "Service endpoints to add to the default subnet"
  type        = list(string)
  default     = []
}

variable "hub_private_endpoint_network_policies_enabled" {
  type        = any
  description = "Whether or not to enable network policies on the private endpoint subnet"
  default     = null
}

variable "hub_private_link_service_network_policies_enabled" {
  type        = any
  description = "Whether or not to enable service endpoints on the private endpoint subnet"
  default     = null
}

variable "add_subnets" {
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

variable "gateway_private_endpoint_network_policies_enabled" {
  type        = any
  description = "Whether or not to enable network policies on the private endpoint gateway subnet"
  default     = null
}

variable "gateway_private_link_service_network_policies_enabled" {
  type        = any
  description = "Whether or not to enable link service network policies on the private link service gateway subnet"
  default     = null
}
