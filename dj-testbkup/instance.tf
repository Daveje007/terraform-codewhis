# instance
resource "azurerm_virtual_machine" "dj-instance" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.dj.name
  network_interface_ids = [azurerm_network_interface.dj-instance.id]
  vm_size               = "Standard_A1_v2"

  # this is a demo instance, so we can delete all data on termination
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "dj-instance"
    admin_username = "david"
    #admin_password = "..."
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("mykey.pub")
      path     = "/home/dj/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_network_interface" "dj-instance" {
  name                      = "${var.prefix}-instance1"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.dj.name
  network_security_group_id = azurerm_network_security_group.allow-ssh.id

  ip_configuration {
    name                          = "instance1"
    subnet_id                     = azurerm_subnet.dj-internal-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dj-instance.id
  }
}

resource "azurerm_public_ip" "dj-instance" {
    name                         = "instance1-public-ip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.dj.name
    allocation_method            = "Dynamic"
}
