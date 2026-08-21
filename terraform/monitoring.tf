resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-eastus-platform"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku               = "PerGB2018"
  retention_in_days = 30
}

resource "azurerm_monitor_diagnostic_setting" "agw" {

  name                           = "agw-diagnostic"
  target_resource_id             = azurerm_application_gateway.agw.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

