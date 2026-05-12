# tflint-ignore-file: terraform_unused_declarations
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
#
# Rationale: filename is misspelled (varaibles -> variables) and some declared
# variables are not wired into the module body. Rename + wire-up tracked in
# issue #12 (subset of umbrella issue #10).

###########################
# Logging Configuration  ##
###########################

variable "create_logging_resource_group" {
  description = "Controls if the logging resource group should be created. If set to false, the resource group name must be provided. Default is true."
  type        = bool
  default     = true
}

variable "enable_monitoring_private_endpoints" {
  description = "Enables private endpoints for monitoring resources. Default is true."
  type        = bool
  default     = true
}

variable "enable_sentinel" {
  description = "Enables an Azure Sentinel Log Analytics Workspace Solution"
  type        = bool
  default     = true
}

variable "enable_defender_for_cloud" {
  description = "Enables Azure Defender for Cloud. Default is true."
  type        = bool
  default     = true
}

variable "log_analytics_workspace_sku" {
  description = "The SKU of the Log Analytics Workspace. Possible values are PerGB2018 and Free. Default is PerGB2018."
  type        = string
  default     = null
}

variable "log_analytics_logs_retention_in_days" {
  description = "The number of days to retain logs for. Possible values are between 30 and 730. Default is 30."
  type        = number
  default     = null
}