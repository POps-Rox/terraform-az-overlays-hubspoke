# tflint-ignore-file: terraform_unused_declarations
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
#
# Rationale: declared module input surface; several vars are forward-/backward-compat
# placeholders or are tracked as deferred wire-up. See umbrella issue #10 and the
# specific WIP follow-ups in issue #12.


###########################
# Global Configuration   ##
###########################

variable "environment" {
  description = "The Terraform backend environment e.g. public or usgovernment"
  type        = string
  default     = null
}

variable "metadata_host" {
  description = "The metadata host for the Azure Cloud e.g. management.azure.com or management.usgovcloudapi.net."
  type        = string
  default     = null
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string
}

variable "org_name" {
  description = "A name for the organization. It defaults to anoa."
  type        = string
  default     = "anoa"
}

variable "workload_name" {
  description = "A name for the workload. It defaults to ops-logging-core."
  type        = string
  default     = "hub-core"
}

variable "deploy_environment" {
  description = "The environment to deploy. It defaults to dev."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
  type        = map(string)
}

#######################
# RG Configuration   ##
#######################

variable "create_hub_resource_group" {
  description = "Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is true."
  type        = bool
  default     = true
}

variable "use_location_short_name" {
  description = "Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored."
  type        = bool
  default     = true
}

#######################
# PE Configuration   ##
#######################

variable "create_private_endpoint" {
  description = "Controls if the private endpoint should be created. If set to false, the private endpoint name must be provided. Default is true."
  type        = bool
  default     = true
}

variable "private_endpoint_subnet_id" {
  description = "The subnet id where the private endpoint will be created."
  type        = string
}