# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {
  required_version = ">= 1.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.20"
    }
    popsrox = {
      source  = "POps-Rox/azutils"
      version = "~> 1.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0"
    }
  }
}

provider "azapi" {
  environment     = "usgovernment"
  subscription_id = "<<subscription_id>>"
}

provider "azurerm" {
  environment     = "usgovernment"
  metadata_host   = "management.usgovcloudapi.net"
  subscription_id = "<<subscription_id>>"

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "hub"
  environment     = "usgovernment"
  metadata_host   = "management.usgovcloudapi.net"
  subscription_id = "<<subscription_id>>"

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "ops"
  environment     = "usgovernment"
  metadata_host   = "management.usgovcloudapi.net"
  subscription_id = "<<subscription_id>>"

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "svcs"
  environment     = "usgovernment"
  metadata_host   = "management.usgovcloudapi.net"
  subscription_id = "<<subscription_id>>"

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "id"
  environment     = "usgovernment"
  metadata_host   = "management.usgovcloudapi.net"
  subscription_id = "<<subscription_id>>"

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

# tflint-ignore: terraform_unused_declarations  # WIP: workload-spoke azurerm.wl provider not yet wired into any module call. See issue #12.
provider "azurerm" {
  alias           = "wl"
  environment     = "usgovernment"
  metadata_host   = "management.usgovcloudapi.net"
  subscription_id = "<<subscription_id>>"

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}
