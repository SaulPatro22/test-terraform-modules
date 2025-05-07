module "my-module-repo" {
    source = "github.com/stemdo-labs/terraform-exercises-SaulPatro-22.git//soluciones/ejercicio_5/ficheros?ref=main"

    existent_resource_group_name = var.existent_resource_group_name
    vnet_name = var.vnet_name
    vnet_address_space = var.vnet_address_space
    location = var.location
    owner_tag = var.owner_tag
    environment_tag = var.environment_tag
}