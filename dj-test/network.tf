
resource "azurerm_virtual_network" "dj" {
  name                = "${var.prefix}-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.dj.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "dj-internal-1" {
  name                 = "${var.prefix}-internal-1"
  resource_group_name  = azurerm_resource_group.dj.name
  virtual_network_name = azurerm_virtual_network.dj.name
  address_prefix       = "10.0.0.0/24"
}

resource "azurerm_network_security_group" "allow-ssh" {
    name                = "${var.prefix}-allow-ssh"
    location            = var.location
    resource_group_name = azurerm_resource_group.dj.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.ssh-source-address
        destination_address_prefix = "*"
    }
}
