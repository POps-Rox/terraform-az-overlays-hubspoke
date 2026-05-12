# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Local Tags configuration - Default (required). 
#-----------------------------------------------------------

locals {
  # tflint-ignore: terraform_unused_declarations  # WIP: see issue #12 — not yet merged into module tags.
  default_tags = var.default_tags_enabled ? {
    env      = var.deploy_environment
    workload = var.workload_name
  } : {}
}