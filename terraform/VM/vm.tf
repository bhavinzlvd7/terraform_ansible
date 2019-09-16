resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = var.name
  network_interface_ids = [var.netid]
  vm_size               = "Standard_F2s_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = var.os_disk_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = 30
  }
  os_profile {
    computer_name  = var.os_comp_name
    admin_username = var.admin_uname
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
        path     = "/home/${var.admin_uname}/.ssh/authorized_keys"
        key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }
  tags = {
    environment = "staging"
  }
}