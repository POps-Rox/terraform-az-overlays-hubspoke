# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Azure Region Lookup
#----------------------------------------------------------
module "mod_azregions" {
  source = "github.com/POps-Rox/terraform-az-overlays-azregionslookup?ref=v2.0.0"

  azure_region = var.location
}

#---------------------------------------------------------
# Resource Group Creation
#----------------------------------------------------------
# tflint-ignore: terraform_unused_declarations  # WIP: "use existing RG" path not wired downstream. See issue #12.
data "azurerm_resource_group" "rgrp" {
  count = var.create_spoke_resource_group == false ? 1 : 0
  name  = var.custom_resource_group_name
}

module "mod_spoke_rg" {
  source = "github.com/POps-Rox/terraform-az-overlays-resourcegroup?ref=v2.0.0"

  count = var.create_spoke_resource_group ? 1 : 0

  location                = module.mod_azregions.location_cli
  use_location_short_name = var.use_location_short_name # Use the short location name in the resource group name
  org_name                = var.org_name
  environment             = var.deploy_environment
  workload_name           = var.workload_name
  custom_rg_name          = var.custom_resource_group_name != null ? var.custom_resource_group_name : null

  // Tags
  add_tags = merge(var.tags, {
    DeployedBy = format("AzureNoOpsTF [%s]", terraform.workspace)
  }) # Tags to be applied to all resources
}
