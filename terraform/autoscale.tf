resource "azurerm_monitor_autoscale_setting" "vmss" {

  name                = "vmss-autoscale"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  target_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id

  profile {

    name = "production"

    capacity {
      minimum = 2
      maximum = 5
      default = 2
    }

    rule {

      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        operator           = "GreaterThan"
        threshold          = 70
        statistic          = "Average"
        time_grain         = "PT1M"
        time_window        = "PT5M"
        time_aggregation   = "Average"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {

      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        operator           = "LessThan"
        threshold          = 30
        statistic          = "Average"
        time_grain         = "PT1M"
        time_window        = "PT10M"
        time_aggregation   = "Average"
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }
  }
}
