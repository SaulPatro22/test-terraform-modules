# Ejercicio 3
## Añadiendo nuevas variables
En el fichero variables.tf vamos a añadir las siguientes líneas a lo que se realizo en el ejercicio anterior.

```.tf
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
```

*owner_tag* y *environment_tag* son variables obligatorias ya que no incluyen un valor por defecto y deberemos incluirlas en el fichero *``terraform.vars``* o introducirlas cuando hagamos el *terraform apply*.

## Asignando tags a la virtual net
Al recurso *"vnet"* le añadiremos el atributo ``tags``. Como disponemos de varios elementos, usaremos una función llamada *merge* para unir todos en un solo mapa que por definición no incluirá duplicados.

```.tf
  tags = merge( # Devuelve un mapa uniendo los argumentos sin duplicados.
    {
      owner       = var.owner_tag
      environment = var.environment_tag
    },
    var.vnet_tags
  )
```

> [!NOTE]
> En caso de que se indique un atributo varias veces, la función *merge* usará el valor asignado por último. Por eso el último argumento es *vnet_tags*.
> 
> Tags resultantes cuando no existen coincidencias entre *vnet_tags* y *owner* o *environment*:
> 
> ![Tags resultantes sin coincidencias](./images/img-ej2-1.png)
>
> Tags resultantes cuando exiten coincidencias. Se ha incluido en vnet_tags un atributo *owner* con diferente valor.
> 
> ![Tags resultantes con coincidencia](./images/img-ej2-2.png)