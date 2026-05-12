# Changelog

## [v2.0.0] - 2026-05-11

### Breaking changes

* Upgraded to `azurerm` provider `~> 4.20` (was `~> 3.116`).
* Raised Terraform CLI floor from `>= 1.9` to `>= 1.10`.
* Bumped `azure/azapi` to `~> 2.0` (was `~> 1.0`).
* Consumers must set `ARM_SUBSCRIPTION_ID` (azurerm 4.x makes `subscription_id` required for the `azurerm` provider).
* All 6 `azurerm_subnet` resource declarations across `modules/virtual-network-hub` and `modules/virtual-network-spoke` switched from the 3.x bool `private_endpoint_network_policies_enabled` to the 4.x string-enum `private_endpoint_network_policies`. **All `bool` module input variables and map keys are preserved** — translation happens at the resource boundary (`true → "Enabled"`, `false → "Disabled"`, `null → null`).
* Both `azurerm_route_table` resources (`modules/virtual-network-{hub,spoke}/route-table.tf`) switched from the 3.x `disable_bgp_route_propagation` to the 4.x `bgp_route_propagation_enabled` (semantics inverted; the module `var.disable_bgp_route_propagation` is preserved, the inversion happens at the resource boundary).
* `azurerm_security_center_contact.main` (`modules/operational-logging/defender.tf`) gained a `name` argument — required in 4.x; defaults to `"default"`, overridable via `var.security_center_contacts.name`. The pre-4.x implicit default was the literal string `"default"`.

### Notes — forward compatibility

* `azurerm_security_center_auto_provisioning` emits a `Deprecated Resource` *warning* in 4.x (will be removed in 5.x). Not removing in this PR — track for Phase 2.
* `popsrox` local provider name retained.
* All `configuration_aliases = [azurerm.hub_network]` declarations preserved.


All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).
