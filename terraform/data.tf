data "azurerm_resource_group" "rg" {
  name = "1-d80b01f8-playground-sandbox"
}

data "azurerm_client_config" "current" {}
