resource "azurerm_key_vault" "kv" {
  name                = "mykey-scret"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = "standard"

  enable_rbac_authorization = true

  purge_protection_enabled   = false
  soft_delete_retention_days = 90

  public_network_access_enabled = true

  tags = {
    Environment = "Lab"
  }
}

resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = "azureuser-private-key"
  value        = file("${path.module}/azureuser-priv-key.pem")
  key_vault_id = azurerm_key_vault.kv.id

}
