# Ejercicio 02

## Objetivo
- Parametrizar un módulo raíz básico de Terraform.
- Introducción al uso de bloques "data" en Terraform.


## Solución
### Fichero terraform.tfvars
Aquí emparejaremos variables con un valor:
```.tfvars
existent_resource_group_name = "rg-spatrocinio-dvfinlab"
vnet_name = "vnetsaultfexercise01"
vnet_address_space = ["10.0.0.0/16"]
location = "westeurope"
```

> [!NOTE]
> Si en el fichero que mostraremos a continuación (*variables.tf*) indicamos valores por defecto, se podrían comentar en el .tfvars y se usarían esas.

### Fichero variables.tf
En este definimos bloques *variable* donde definimos variables con su tipo y opcionalmente su valor por defecto. 

Se forman de la siguiente manera:
```.tf
variable "<nombre-variable>" {
  description = "<Descripción-de-la-variable>"
  type        = <tipo-variable> # Ejemplo: string o list(string)
  default     = "<valor-por-defecto>" # Opcional
}
```

> ![NOTE]
> Las variables definidas cuyo nombre coincida con una variable del fichero ``terraform.tfvars``, usará el valor encontrado en dicho fichero.

En el fichero se definen las siguientes variables:
- **"existent_resource_group_name"** de tipo *string*
- **"vnet_name"** de tipo *string*
- **"vnet_address_space"** de tipo *list(string)*
- **"location"** de tipo *string*

### Fichero main.tf
Omitiendo el bloque *terraform* y *provider* nos encontramos con lo siguiente:
```.tf
data "azurerm_resource_group" "existing" {
  name = var.existent_resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  resource_group_name = data.azurerm_resource_group.existing.name # O referenciar directamente con *var.existent_re...*
  location            = var.location
}
```

#### Bloque data
El bloque *data* es usado para referenciar un recurso, basicamente se solicita a terraform que ela el recurso especificado. 

Junto a *data* se incluyen dos valores, uno para indicar el tipo de recurso y otro será la etiqueta local para referenciarlo en otros lugares. Dentro del bloque se incluye el parametro *name* que se usa para determinar el grupo a leer.

#### Definir una virtual net
Para definir una virtual net dentro del grupo de recursos usamos el recurso *"azurerm_virtual_network"* donde definimos los siguientes parámetros:

- **``name``**: El nombre dado a la virtual network.
- **``address_space``**: El rango de direcciones IPs asignadas a la Vnet.
- **``resource_group_name``**: El nombre del grupo de recursos donde se creará el recurso.
- **``location``**: La ubicación donde se creará dicha Vnet.

![Vnet en el portal de Azure](./images/img-ej3-1.png)