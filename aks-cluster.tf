# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "prefix" {}



provider "azurerm" {
  skip_provider_registration = true
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "${random_pet.prefix.id}-rg"
  location = "West Europe" # Updated to West Europe

  tags = {
    environment = "Demo"
  }
}
resource "azurerm_kubernetes_cluster" "default" {
  name                = "${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"
  kubernetes_version  = "1.29"  # Updated to a supported version
  
  # Rest of your configuration...

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_d2s_v5" # Changed to an allowed VM size
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control_enabled = true

  tags = {
    environment = "Demo"
  }
}
