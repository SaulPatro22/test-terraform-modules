variable "existent_resource_group_name" {
  description = "Resource group name where the resources will be created"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string

  validation {
    condition = (
        var.vnet_name == null ? false : 
        (
            can(regex("^vnet[a-z]{3,}tfexercise[0-9]{2,}$", var.vnet_name))
        )
    )
    error_message = "El valor para el *vnet_name* debe comenzar por 'vnet', seguido de 2 letras minusculas, y tras lo que sea, se debe acabar en 'tfexercise' seguido de 2 o mas digitos."
  }
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

  validation {
    condition = (
        var.owner_tag != "" && var.owner_tag != null
    )
    error_message = "El valor para el *owner_tag* no puede ser nulo o estar vacio."
  }
}

variable "environment_tag" {
  description = "Describe el entorno de la Vnet (dev, tes, pro, pre)"
  type        = string

  validation {
    condition = (
        var.environment_tag == null ? false : 
        (
            contains(["dev", "tes", "pro", "pre"], lower(var.environment_tag)) ? true : false
        )
    )
    error_message = "El valor para el *environment_tag* debe ser una de las siguientes opciones: \"dev\", \"tes\", \"pro\", \"pre\"."
  }
}

variable "vnet_tags" {
  description = "Tags a aplicar en la Virtual Network"
  type        = map(string)
  default     = { owner = "no-one" }

  validation {
    condition = (
        var.vnet_tags == null ? false :
        alltrue([for value in values(var.vnet_tags) : value != null])
    )

    error_message = "vnet_tags no puede ser null, sus valores tampoco"
  }
}