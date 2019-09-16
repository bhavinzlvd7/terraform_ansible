resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = var.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = var.name

  ip_configuration {
    name                          = var.ip_conf_name
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pubip.id
  }
}

resource "azurerm_public_ip" "pubip" {
  name                = "PublicIp1"
  location            = var.location
  resource_group_name = var.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "mytfnsg" {
  location = var.location
  name = "mytfnsg"
  resource_group_name = var.name
  security_rule {
    access = "Allow"
    direction = "Inbound"
    name = "SSH"
    priority = 200
    protocol = "TCP"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "mysqlSG" {
  location = var.location
  name = "mysqlSG"
  resource_group_name = var.name

  security_rule {
    access = "Allow"
    direction = "Inbound"
    name = "mysqlip"
    priority = 100
    protocol = "TCP"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    source_port_range = "*"
    destination_port_range = "*"
  }
}
