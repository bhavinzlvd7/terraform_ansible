/*
output "mysqlIp" {
  value = azurerm_mysql_server.mysqlex.id
}
*/

output "mydb" {
  value = azurerm_mysql_server.mysqlex
}