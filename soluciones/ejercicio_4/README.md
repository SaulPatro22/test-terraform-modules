# Ejercicio 4
## Añadiendo validaciones a las variables
Para añadir validaciones a las variables, añadimos el bloque **``validation``** dentro de los *variable* que queramos validar. Será dentro de dicho bloque donde tengamos el atributo *condition* en el que definimos las condiciones a cumplir y *error_message* que se mostrará en caso de que no sea valido.

### Validaciones ``owner_tag``
Como se quiere comprobar si es una cadena vacia o null, introducimos la siugiente validación:
```.tf
  validation {
    condition = (
        var.owner_tag != "" && var.owner_tag != null
    )
    error_message = "El valor para el *owner_tag* no puede ser nulo o estar vacio."
  }
```

#### Pruebas de ejecución erróneas
Con la tag vacia:

![Ejecución con la tag vacia](./images/img-ej1-1.png)

Con la tag a null:

![Ejecución con la tag nula](./images/img-ej1-2.png)


### Validaciones ``environment_tag``
La condición que debe cumplir es la siguiente: Solo se aceptará los valores ["dev", "tes", "pro", "pre"] ignorando minúsculas.

Para ello usaremos la función *contains*. Con esta función comprobaremos si el valor se encuentra dentro de la lista antes dicha. Para ignorar la capitalización, usamos la función *lower* para que el valor recibido sea minúsculas. Esto resulta en la siguiente expresión:

**``contains(["dev", "tes", "pro", "pre"], lower(var.environment_tag))``**

El bloque *validation* queda así:
```.tf
  validation {
    condition = (
        var.environment_tag == null ? false : (
            contains(["dev", "tes", "pro", "pre"], lower(var.environment_tag)) ? true : false
        )
    )
    error_message = "El valor para el *environment_tag* debe ser una de las siguientes opciones: \"dev\", \"tes\", \"pro\", \"pre\"."
  }
```

#### Pruebas de ejecución
Indicando un valor vacio:

![Ejecución con un valor vacio](./images/img-ej2-1.png)

Indicando un valor erroneo:

![Ejecución con ter](./images/img-ej2-2.png)

Ejecutando valor con mayusculas:

![Ejecución con deV](./images/img-ej2-3.png)

### Validaciones ``vnet_tags``
*vnet_tags* no puede ser nulo y los valores del mapa tampoco pueden serlo. Teniendo en mente esto, usaremos la función values para obtener una lista con los valores del mapa. Con dicha lista y la función *allTrue* podremos comprobar si se han incluido nulos:

```.tf
  validation {
    condition = (
        var.vnet_tags == null ? false :
        alltrue([for value in values(var.vnet_tags) : value != null])
    )

    error_message = "vnet_tags no puede ser null, sus valores tampoco"
  }
```

#### Pruebas de ejecución
Ejecución con mapa nulo:

![Ejecución con mapa nulo](./images/img-ej3-1.png)

Ejecución con valores nulos:

![Ejecución con un valor nulo](./images/img-ej3-2.png)


### Validaciones ``vnet_name``
Las condiciones que debe cumplir son las siguientes:
- Debe comenzar por 'vnet' (*``^vnet``*).
- Tras 'vnet', siguen más de dos letras minusculas (*``[a-z]{3,}``*).
- Termina con 'tfexercise' y dos o más números (*``tfexercise[0-9]{2,}$``*).

> [!NOTE]
> Los caracteres **``^``** y **``$``** indican el principio y el final de la cadena.


La cadena con la expresión regular queda así: **``"^vnet[a-z]{3,}.*tfexercise[0-9]{2,}$"``**

> [!NOTE]
> Los carácteres ``.*`` que se encuentran en la expresión regular permiten que haya cualquier cosa entre las letras minusculas y el final de la cadena (*ftexe...*), de manera que *vnetsaul22tfexercise04* sería valido. Como entiendo que ese no es el objetivo, se ha quitado de la expresión final.


Antes de llamar a la función *regex* se usa una llamada *can* que envuelve la ejecución de regex con el fin de que, en lugar de lanzar un error en caso de no encontrar coincidencias, solo se devuelva true o false.

La expresión para la validación queda así:
```.tf
  validation {
    condition = (
        var.vnet_name == null ? false : 
        (
            can(regex("^vnet[a-z]{3,}tfexercise[0-9]{2,}$", var.vnet_name))
        )
    )
    error_message = "El valor para el *vnet_name* debe comenzar por 'vnet', seguido de 2 letras minusculas, y tras lo que sea, se debe acabar en 'tfexercise' seguido de 2 o mas digitos."
  }
```

#### Pruebas de ejecución erróneas
Un valor válido sería `"vnetsaultfexercise04"`. Los siguientes no son validos:
1. `vnetprodrigueztfexercise`
![Error de validación](./images/img-ej4-1.png)

2. `vnetprodrigueztfexercises01`
![Error de validación](./images/img-ej4-2.png)

3. `vnetProdrigueztfexercise01`
![Error de validación](./images/img-ej4-3.png)

4. `vnetpr0drigu3ztfexercise01`
![Error de validación](./images/img-ej4-4.png)