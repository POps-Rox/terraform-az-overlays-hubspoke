# tflint-ignore-file: terraform_unused_declarations
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
#
# Rationale: declared module input surface; several vars are forward-/backward-compat
# placeholders or are tracked as deferred wire-up. See umbrella issue #10 and the
# specific WIP follow-ups in issue #12.

variable "hub_virtual_network_id" {
  description = "The ID of the hub virtual network to peer with the spoke virtual network."
  type        = string
}

###############
# SRC PEER CONF
###############

variable "allow_virtual_spoke_network_access" {
  description = "Option allow_virtual_network_access for the spoke vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access"
  type        = bool
  default     = false
}

variable "allow_forwarded_spoke_traffic" {
  description = "Option allow_forwarded_traffic for the spoke vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic"
  type        = bool
  default     = false
}

variable "allow_gateway_spoke_transit" {
  description = "Option allow_gateway_transit for the spoke vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit"
  type        = bool
  default     = false
}

variable "use_remote_spoke_gateway" {
  description = "Option use_remote_gateway for the spoke vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = false
}

################
# DEST PEER CONF
################

variable "allow_virtual_hub_network_access" {
  description = "Option allow_virtual_network_access for the hub vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access"
  type        = bool
  default     = false
}

variable "allow_forwarded_hub_traffic" {
  description = "Option allow_forwarded_traffic for the hub vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic"
  type        = bool
  default     = false
}

variable "allow_gateway_hub_transit" {
  description = "Option allow_gateway_transit for the hub vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit"
  type        = bool
  default     = false
}

variable "use_remote_hub_gateway" {
  description = "Option use_remote_gateway for the hub vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = false
}