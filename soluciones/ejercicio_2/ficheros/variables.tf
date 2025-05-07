variable "existent_resource_group_name" {
  description = "Resource group name where the resources will be created"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space of the Virtual Network"
  type        = list(string)
}

variable "location" {
  description = "Location of the resources"
  type        = string
  default     = "westeurope" # Instead of using the display name (West Europe), use the name.
}