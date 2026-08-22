output "bastion_public_ip" {
  value = azurerm_public_ip.bastion.ip_address
}

output "application_gateway_public_ip" {
  value = azurerm_public_ip.agw.ip_address
}

output "mysql_server_name" {
  value = azurerm_mysql_flexible_server.mysql.name
}


