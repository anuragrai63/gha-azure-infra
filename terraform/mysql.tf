resource "random_string" "mysql" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_private_dns_zone" "mysql" {
  name                = "mysql.private"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "mysql-link"
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "mysql-${random_string.mysql.result}"
  resource_group_name    = data.azurerm_resource_group.rg.name
  location               = data.azurerm_resource_group.rg.location

  administrator_login    = "admin1"
  administrator_password = "A#xanu23"

  sku_name = "B_Standard_B1ms"

  delegated_subnet_id = azurerm_subnet.db.id
  private_dns_zone_id = azurerm_private_dns_zone.mysql.id
}
