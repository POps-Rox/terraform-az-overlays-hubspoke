# tflint-ignore-file: terraform_unused_declarations
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
#
# Rationale: declared module input surface; several vars are forward-/backward-compat
# placeholders or are tracked as deferred wire-up. See umbrella issue #10 and the
# specific WIP follow-ups in issue #12.

# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_naming" {
  description = "Use the Azure CAF naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}

# Custom naming override
variable "custom_resource_group_name" {
  description = "The name of the resource group to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "custom_ops_resource_group_name" {
  description = "The name of the resource group to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "custom_logging_resource_group_name" {
  description = "The name of the logging resource group to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_vnet_custom_name" {
  description = "The name of the custom virtual network to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_fw_custom_name" {
  description = "The name of the custom virtual network firewall to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_snet_custom_name" {
  description = "The name of the custom virtual network subnet to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_nsg_custom_name" {
  description = "The name of the custom virtual network network security group to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_fw_client_pip_custom_name" {
  description = "The name of the custom virtual network firewall client public IP to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_fw_mgt_pip_custom_name" {
  description = "The name of the custom virtual network firewall management public IP to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_routtable_custom_name" {
  description = "The name of the custom virtual network route table to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_sa_custom_name" {
  description = "The name of the custom virtual network storage account to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

# Custom Ops naming override
variable "ops_logging_sa_custom_name" {
  description = "The name of the custom operational logging storage account to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

# Custom Ops Logging naming override
variable "custom_ops_vnet_name" {
  type        = any
  description = "(Optional) Specifies the custom name of the vnet for the ops vnet. If not specified, the default naming is used"
  default     = null
}

variable "ops_logging_law_custom_name" {
  description = "The name of the custom operational logging laws workspace to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}