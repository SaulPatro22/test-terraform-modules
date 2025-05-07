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

variable "owner_tag" {
  description = "Describe el dueño de la Vnet"
  type        = string
}

variable "environment_tag" {
  description = "Describe el entorno de la Vnet (dev, test, prod, etc)"
  type        = string
}

variable "vnet_tags" {
  description = "Tags a aplicar en la Virtual Network"
  type        = map(string)
  default     = { owner = "otro_spatrocinio" }
}