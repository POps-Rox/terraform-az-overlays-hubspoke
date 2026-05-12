# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

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