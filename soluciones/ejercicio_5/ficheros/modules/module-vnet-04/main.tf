# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.27.0"
    }
  }
 
  # required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "existing" {
  name = var.existent_resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  resource_group_name = data.azurerm_resource_group.existing.name # O referenciarlo con var
  location            = var.location
  tags = merge( # Devuelve un mapa uniendo los argumentos sin duplicados.
    {
      owner       = var.owner_tag
      environment = var.environment_tag
    },
    var.vnet_tags
  )
}