resource "azurerm_virtual_network" "main" {
  name                = "my-vnet"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  address_space = ["172.16.0.0/16"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = ["172.16.10.0/24"]
}

resource "azurerm_subnet" "app" {
  name                 = "APP-Subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = ["172.16.20.0/24"]
}

resource "azurerm_subnet" "db" {
  name                 = "DB-Subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = ["172.16.30.0/24"]

 
}

resource "azurerm_subnet" "web" {
  name                 = "WEB-Subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = ["172.16.40.0/24"]
}

resource "azurerm_subnet" "agw" {
  name                 = "AppGatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = ["172.16.50.0/24"]
}
