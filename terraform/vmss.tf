resource "azurerm_linux_virtual_machine_scale_set" "vmss" {

  name                = "app-vmss"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku       = "Standard_B2s"
  instances = 2

  zones = ["1", "2"]

  admin_username = "azureuser"

  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh.public_key_openssh
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vmssnic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.app.id
    }
  }

  custom_data = base64encode(<<EOF
#!/bin/bash
apt-get update -y
apt-get install apache2 mysql-client -y
systemctl enable apache2
systemctl start apache2
EOF
  )
}
