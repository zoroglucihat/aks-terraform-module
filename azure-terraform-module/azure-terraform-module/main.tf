terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  vnet_name           = "aks-vnet"
  subnet_name         = "aks-subnet"
  nsg_name            = "aks-nsg"
  address_space       = "10.0.0.0/16"
  subnet_prefix       = "10.0.1.0/24"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

module "keyvault" {
  source              = "./modules/keyvault"
  keyvault_name       = "aks-keyvault-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = var.tenant_id
}

module "aks" {
  source              = "./modules/aks"
  cluster_name        = "aks-cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks"
}
