# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

############################
# Subnet Configuration    ##
############################

variable "spoke_subnet_address_prefix" {
  description = "The address prefixes to use for the default subnet"
  type        = list(string)
  default     = []
}

variable "spoke_subnet_service_endpoints" {
  description = "Service endpoints to add to the default subnet"
  type        = list(string)
  default     = []
}

variable "spoke_private_endpoint_network_policies_enabled" {
  type        = any
  description = "Whether or not to enable network policies on the private endpoint subnet"
  default     = null
}

variable "spoke_private_link_service_network_policies_enabled" {
  type        = any
  description = "Whether or not to enable service endpoints on the private endpoint subnet"
  default     = null
}

variable "add_subnets" {
  type        = any
  description = "A list of subnets to add to the spoke"
  default     = {}
}


