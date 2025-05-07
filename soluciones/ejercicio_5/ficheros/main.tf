module "my_vnet_module" {
    source = "./modules/module-vnet-04"

    existent_resource_group_name = var.existent_resource_group_name
    vnet_name = var.vnet_name
    vnet_address_space = var.vnet_address_space
    location = var.location
    owner_tag = var.owner_tag
    environment_tag = var.environment_tag
}