# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  spoke_vnet_name    = coalesce(var.spoke_vnet_custom_name, data.popsrox_resource_name.vnet.result)
  spoke_snet_name    = coalesce(var.spoke_snet_custom_name, data.popsrox_resource_name.snet.result)
  spoke_snet_pe_name = data.popsrox_resource_name.snet.result
  spoke_nsg_name     = coalesce(var.spoke_nsg_custom_name, data.popsrox_resource_name.nsg.result)
  spoke_rt_name      = coalesce(var.spoke_routtable_custom_name, data.popsrox_resource_name.rt.result)
  spoke_sa_name      = coalesce(var.spoke_sa_custom_name, data.popsrox_resource_name.st.result)
}
