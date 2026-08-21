

resource "azurerm_private_dns_zone" "mysql" {
  name                = "gmvmysql2108.private.database.azure.com"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "gmvmysql2108"
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "gmvmysql2108"
  resource_group_name    = data.azurerm_resource_group.rg.name
  location               = data.azurerm_resource_group.rg.location
  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql]

  administrator_login    = "admin1"
  administrator_password = "A#xanu23"

  sku_name = "B_Standard_B1ms"

  delegated_subnet_id = azurerm_subnet.db.id
  private_dns_zone_id = azurerm_private_dns_zone.mysql.id
}
