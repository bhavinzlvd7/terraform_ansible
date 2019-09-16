resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.rg_location
}

module "my_vm" {
  source = "./VM/"
  location = azurerm_resource_group.main.location
  name = azurerm_resource_group.main.name
  netid = module.my_vnet.network_interface_id
  prefix = var.prefix
}

module "my_vnet" {
  source = "./Vnet/"
  location = azurerm_resource_group.main.location
  name = azurerm_resource_group.main.name
  prefix = var.prefix
  virtual_machine = module.my_vm.vitual_machine_name
  mydb = module.my_db.mydb
}

module "my_db" {
  source = "./DB/"
  location = azurerm_resource_group.main.location
  name = azurerm_resource_group.main.name
  prefix = var.prefix
  public_ip = module.my_vnet.public_ip
}

provider "azurerm" {
}
