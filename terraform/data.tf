data "azurerm_resource_group" "rg" {
  name = "1-495e5ab1-playground-sandbox"
}

data "azurerm_client_config" "current" {}
