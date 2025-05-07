# Ejercicio 5
## Estructura recomendada
La estructura recomendad por HashiCorp, como se observa en este [enlace](https://developer.hashicorp.com/terraform/language/modules/develop/structure), es crear una carpeta llamada ``modules`` donde se incorporarán los módulos en su carpeta propia. Incluyendo los ficheros recomendados, la estructura queda así:
```
$ tree ficheros/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── ...
├── modules/
│   ├── nestedA/
│   │   ├── README.md
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
```

> [!NOTE]
> He observado que se podría llamar directamente al módulo con rutas relativas indicando en source los siguiente *``"../../ejercicio_4/ficheros"``*. No parece que sea lo recomendao y se ha optado por copiar los ficheros.

## Añadiendo un submódulo
Siguiendo dicha estructura, copiaremos el módulo realizado anteriormente a una carpeta dentro de *modules* llamada ``module-vnet-04``. Ahí incluiremos los ficheros que se muestran en la estructura de arriba. Se podría incluir adiccionalmente un fichero con la licencia (*LICENSE*).

## Creando el módulo principal
Creamos la estructura básica con los ficheros *main.tf*, *variables.tf*, *terraform.tfvars*, *outputs* y el *README.md*.

> [!NOTE]
> Los ficheros ***variables.tf*** y ***terraform.tfvars*** fueron copiados de dicho submódulo ya que no se reutilizara dichos valores y tener centralizados los valores suena mejor.
> 
> Se podría utilizar el fichero *terraform.tfvars* usando el argumento ``-var-file=${ruta-submodulo}/terraform.tfvars`` al ejecutar el comando plan.

### Llamando al submodulo desde el main.tf
Para llamar a un módulo usamos el bloque *module*, en el indicamos el parámetro *source* con la ruta al submodulo para que lo referencie e incluimos los atributos obligatorios de la siguiente manera:
```.tf
module "my_vnet_module" {
    source = "./modules/module-vnet-04"

    existent_resource_group_name = var.existent_resource_group_name
    vnet_name = var.vnet_name
    vnet_address_space = var.vnet_address_space
    location = var.location
    owner_tag = var.owner_tag
    environment_tag = var.environment_tag
}
```

## Resultado ejecución
![Creación usando el main referenciando el submódulo](./images/img-ej1-1.png)

![Luz, Fuego, ¡Destrucción!](./images/img-ej1-2.png)