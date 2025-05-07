# Solución Ejercicio 1 - Tutorial Build Infrastructure
En esta solución se han seguido los pasos encontrados en este [Tutorial Guiado](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build).

## Prerequisites
- Una subscripción de Azure. (*suficiente con los servicios incluidos en una cuenta gratuita de Azure*)
- Terraform 1.2.0+ instalado localmente.
- El *Command-Line Interface* de Azure.

## Instalación de Terraform
Se debe descargar el binario compilado correcto que podemos descargar en la [web oficial](https://developer.hashicorp.com/terraform/install).
Debemos guardar el fichero en una carpeta que recordemos ya que incluiremos la ruta al mismo en las variables de entorno de nuestro sistema.

En mi caso el binario se encuentra dentro de la siguiente ruta: `C:\Program Files\Terraform`.

Para incluir esa misma ruta en las variables de entorno de Windows hacemos lo siguiente:
1. Clic en la tecla Windows y buscamos *variables de entorno del sistema*.
2. Clic en el botón de abajo llamado `Variables de entorno...`.
3. En la parte inferior, *Variables del sistema*, hacemos doble-clic en la variable **path**.
4. Añadimos la ruta `C:\Program Files\Terraform` en una fila nueva.

> [!NOTE]
> En la ruta que añadimnos al **path** no incluimos el fichero `terraform.exe`, solo la ruta hasta la carpeta que lo contiene.

![Versión de terraform instalada](./images/img-ej1-1.png)

## Instalación de Azure CLI
Se usará PowerShell como administrador para la descarga e instalación del mismo.

La siguiente línea hace uso de tres comandos que:
1. Realiza una petición a una Uri que permite acceder al fichero de instalación y almacenarlo en el fichero *``AzureCLI.msi``*.
2. Inicia el proceso `msiexec.exe` usado para la instalación de ficheros *msi*. Indicamos que powershell debe esperar a la finalización de la instalación antes de continuar con el argumento **-Wait**. Y por último con *-ArgumentList* Indicamos una serie de argumentos que se enviarán al proceso; en este caso, el fichero a instalar y */quiet* que permite hacer una instalación sin prompts.
3. Por último se elimina el fichero `AzureCLI.msi` una vez finalizada la instalación.

```
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
```

***Aquí me acorde de que solo era una línea para las explicaciones...***

![Versión de terraform y Azure CLI](./images/img-ej1-2.png)


## Autenticarte usando Azure CLI
Para logearte basta con ejecutar el comando ``az login``. Se abrirá una ventana donde iniciar sesión y tras ello se seleccionará una de las subscripciones disponibles.

![Resultado final tras la ejecución](./images/img-ej2-1.png)


## Crear un *'Service Principal'*

Con el siguiente comando lo crearemos:

```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

> [!NOTE]
> El Service principal en mi caso fue proporcionado por la empresa.

## Seteando las variables de entorno
Con el fin de no guardar datos sensibles en ficheros de la configuración de Terraform, se usarán variables de entorno en la sesión del terminal.
En el apartado anterior se puede observar en el resultado del comando los cuatro valores que debemos asignar a las variables de entorno.
En caso de no haber ejecutado el comando podemos usar los siguientes para recabar los datos:

- Client ID: `az ad sp list --display-name NOMBRE_DE_TU_SP`
- Client Secret: **Solo accesible desde la web.**
- Suscription ID: `az account show --query id --output tsv`
- Tennant ID: `az account show --query tennantId --output tsv`

Cuando se disponga de los valores los seteamos en un terminal de powershell de la siguiente manera:
```
$Env:ARM_CLIENT_ID = "<APPID_VALUE>"
$Env:ARM_CLIENT_SECRET = "<PASSWORD_VALUE>"
$Env:ARM_SUBSCRIPTION_ID = "<SUBSCRIPTION_ID>"
$Env:ARM_TENANT_ID = "<TENANT_VALUE>"
```

> [!NOTE]
> Se ha incluido un script en la carpeta auxiliar que establece las variables de entorno a partir del *Service Principal name* y el *Client Secret*.

## Escribiendo la configuración
Creamos un directorio con el siguiente comando:
```
New-Item -Path "c:\" -Name "learn-terraform-azure" -ItemType "directory"
```

Creamos un ``main.tf`` con la siguiente información:
```main.tf
# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "existing" {
  name = "rg-spatrocinio-dvfinlab"
}
```

*Se ha incluido un bloque output para mostrar información respecto al grupo existente*
```outputs.tf
output "id" {
  value = data.azurerm_resource_group.existing
}
```

## Prueba de Ejecución
Ejecutamos los siguientes comandos:
- `terraform init`
- `terraform plan -out="terraform.tfplan"`
- `terraform apply "terraform.tfplan"`

![Resultado del apply](./images/img-ej3-1.png)

Por último ejecutamos `terraform destroy`.

![Destrucción terraform](./images/img-ej3-2.png)