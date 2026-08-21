resource "azurerm_key_vault" "kv" {

  name                = "anurag-kv-demo-eastus"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  tenant_id = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"
}


