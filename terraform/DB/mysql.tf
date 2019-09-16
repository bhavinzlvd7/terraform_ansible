resource "azurerm_mysql_server" "mysqlex" {
  administrator_login = "mysqladmin"
  administrator_login_password = "einfochips@123"
  location = var.location
  name = "mysql-server-bz"
  resource_group_name = var.name
  ssl_enforcement = "Disabled"
  version = "5.7"

  sku {
    name     = "B_Gen5_2"
    capacity = 2
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }
}

resource "azurerm_mysql_database" "mydb" {
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  name = "exampledb"
  resource_group_name = var.name
  server_name = azurerm_mysql_server.mysqlex.name
}

resource "azurerm_mysql_firewall_rule" "myfirewallrule" {
  end_ip_address = var.public_ip
  name = "vmip"
  resource_group_name = var.name
  server_name = azurerm_mysql_server.mysqlex.name
  start_ip_address = var.public_ip
}