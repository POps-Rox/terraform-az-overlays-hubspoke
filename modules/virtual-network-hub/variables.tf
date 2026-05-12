# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


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
  description = "A name for the workload. It defaults to hub-core."
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

###########################
# RG Configuration   ##
###########################

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

##########################
# VNet Configuration    ##
##########################

variable "virtual_network_address_space" {
  type        = any
  description = "The address space to be used for the Azure virtual network."
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

variable "dns_servers" {
  type        = any
  description = "List of dns servers to use for virtual network"
  default     = []
}

variable "create_network_watcher" {
  type        = bool
  description = "Controls if Network Watcher resources should be created for the Azure subscription"
  default     = false
}
