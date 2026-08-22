data "azurerm_resource_group" "rg" {
  name = "1-495e5ab1-playground-sandbox"
}

resource "azurerm_ssh_public_key" "azureuser" {
  name                = "azureuser-pubkey"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  public_key = file("${path.module}/azureuser-pub-key.pub")
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {

  name                = "app-vmss"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku       = "Standard_D2s_v3"
  instances = 2

  zones = ["1", "2"]

  admin_username = "azureuser"

  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = data.azurerm_ssh_public_key.vmss_key.public_key
  }

  source_image_reference {
    publisher = "Oracle"
    offer     = "Oracle-Linux"
    sku       = "ol810-lvm-gen2"
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
dnf -y update
dnf -y install httpd mysql

systemctl enable httpd
systemctl start httpd

systemctl stop firewalld
systemctl disable firewalld
EOF
  )
}
