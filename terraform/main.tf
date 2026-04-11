# -------------------------------------------------------------------------
# Data Source: Reference Existing Resource Group
# -------------------------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# =========================================================================
# HUB RESOURCES
# =========================================================================
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "vnet-hub"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/23"]
}

# Hub Default Subnet
resource "azurerm_subnet" "hub_subnet" {
  name                 = "vnet-hub-snet-1"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "hub_nsg" {
  name                = "vnet-hub-snet-1-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_route_table" "hub_rt" {
  name                = "vnet-hub-snet-1-rt"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "hub_nsg_assoc" {
  subnet_id                 = azurerm_subnet.hub_subnet.id
  network_security_group_id = azurerm_network_security_group.hub_nsg.id
}

resource "azurerm_subnet_route_table_association" "hub_rt_assoc" {
  subnet_id      = azurerm_subnet.hub_subnet.id
  route_table_id = azurerm_route_table.hub_rt.id
}

# Hub Bastion Resources
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.0.0/26"]
}

resource "azurerm_public_ip" "bastion_pip" {
  name                = "BastionPIP"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-hub"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Basic"

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

# Hub Firewall Resources
resource "azurerm_subnet" "fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.0.64/26"]
}

resource "azurerm_public_ip" "fw_pip" {
  name                = "fw-pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Hub VM
resource "azurerm_network_interface" "hub_nic" {
  name                = "vm-hub-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hub_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "hub_vm" {
  name                            = "vm-hub"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  size                            = "Standard_B2s"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.hub_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
  }

  source_image_reference {
    publisher = "Oracle"
    offer     = "Oracle-Linux"
    sku       = "8"
    version   = "latest"
  }
}


# =========================================================================
# SPOKE 1 RESOURCES
# =========================================================================
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet-1"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/23"]
}

resource "azurerm_subnet" "vnet1_subnet" {
  name                 = "vnet-1-snet-1"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_security_group" "vnet1_nsg" {
  name                = "vnet1-snet-1-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_route_table" "vnet1_rt" {
  name                = "vnet1-snet-1-rt"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "vnet1_nsg_assoc" {
  subnet_id                 = azurerm_subnet.vnet1_subnet.id
  network_security_group_id = azurerm_network_security_group.vnet1_nsg.id
}

resource "azurerm_subnet_route_table_association" "vnet1_rt_assoc" {
  subnet_id      = azurerm_subnet.vnet1_subnet.id
  route_table_id = azurerm_route_table.vnet1_rt.id
}

# Spoke 1 VM
resource "azurerm_network_interface" "vnet1_nic" {
  name                = "vm-vnet1-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet1_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vnet1_vm" {
  name                            = "vm-vnet1"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  size                            = "Standard_B2s"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.vnet1_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
  }

  source_image_reference {
    publisher = "Oracle"
    offer     = "Oracle-Linux"
    sku       = "8"
    version   = "latest"
  }
}

# =========================================================================
# SPOKE 2 RESOURCES
# =========================================================================
resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet-2"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.2.0.0/23"]
}

resource "azurerm_subnet" "vnet2_subnet" {
  name                 = "vnet-2-snet-1"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_network_security_group" "vnet2_nsg" {
  name                = "vnet2-snet-1-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_route_table" "vnet2_rt" {
  name                = "vnet2-snet-1-rt"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "vnet2_nsg_assoc" {
  subnet_id                 = azurerm_subnet.vnet2_subnet.id
  network_security_group_id = azurerm_network_security_group.vnet2_nsg.id
}

resource "azurerm_subnet_route_table_association" "vnet2_rt_assoc" {
  subnet_id      = azurerm_subnet.vnet2_subnet.id
  route_table_id = azurerm_route_table.vnet2_rt.id
}

# Spoke 2 VM
resource "azurerm_network_interface" "vnet2_nic" {
  name                = "vm-vnet2-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet2_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vnet2_vm" {
  name                            = "vm-vnet2"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  size                            = "Standard_B2s"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.vnet2_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
  }

  source_image_reference {
    publisher = "Oracle"
    offer     = "Oracle-Linux"
    sku       = "8"
    version   = "latest"
  }
}

# =========================================================================
# VNET PEERINGS
# =========================================================================

# Hub <--> Spoke 1
resource "azurerm_virtual_network_peering" "hub_to_vnet1" {
  name                      = "hub-to-vnet1"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "vnet1_to_hub" {
  name                      = "vnet1-to-hub"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Hub <--> Spoke 2
resource "azurerm_virtual_network_peering" "hub_to_vnet2" {
  name                      = "hub-to-vnet2"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "vnet2_to_hub" {
  name                      = "vnet2-to-hub"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
