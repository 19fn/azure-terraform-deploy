data "azurerm_virtual_network" "vnet" {
  name                 = var.vnet_name
  resource_group_name  = var.rg_name 
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet_address
  name                 = each.key
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [ "${each.value}" ]
  depends_on           = [ data.azurerm_virtual_network.vnet ] 
}

resource "azurerm_public_ip" "public_ip" {
  for_each            = toset(var.public_ip_names)
  name                = each.value
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.nic_subnet
  name                = "nic-${each.key}"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "config-${each.key}"
    subnet_id                     = azurerm_subnet.subnet[each.value].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.key == "FRONTEND-PROD-NIC-DEVTEST-EU01" ? azurerm_public_ip.public_ip["PIP-PROD-DEVTEST-EU01"].id : azurerm_public_ip.public_ip["PIP-STAG-DEVTEST-EU01"].id
  }
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_network_security_group" "prod_nsg" {
  name                = var.nsg_prod_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  # SSH
  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${chomp(data.http.myip.body)}"
    destination_address_prefix = "*"
  }

  # HTTP
  security_rule {
    name                       = "WEBSITE"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "assoc_nic_nsg_prod" {
  network_interface_id      = azurerm_network_interface.nic["FRONTEND-PROD-NIC-DEVTEST-EU01"].id
  network_security_group_id = azurerm_network_security_group.prod_nsg.id
}

resource "azurerm_network_security_group" "stag_nsg" {
  name                = var.nsg_stag_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  # SSH
  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${chomp(data.http.myip.body)}"
    destination_address_prefix = "*"
  }

  # HTTP
  security_rule {
    name                       = "WEBSITE"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${chomp(data.http.myip.body)}"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "assoc_nic_nsg_stag" {
  network_interface_id      = azurerm_network_interface.nic["FRONTEND-STAG-NIC-DEVTEST-EU01"].id
  network_security_group_id = azurerm_network_security_group.stag_nsg.id
}

resource "azurerm_linux_virtual_machine" "vms" {
  for_each            = var.vm_nic
  name                = each.key
  resource_group_name = var.rg_name
  location            = var.rg_location
  size                = "Standard_F2s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic[each.value].id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  # Remote connection
  connection {
    type = "ssh"
    host = self.public_ip_address
    user = var.admin_username
    private_key = file("~/.ssh/id_rsa")
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
        "sudo apt-get update",
        "cd /opt && sudo git clone https://github.com/19fn/docker-pack.git",
			  "sudo /bin/bash /opt/docker-pack.sh/install.sh",
			  "cd /opt && sudo git clone https://github.com/19fn/python-web-counter.git",
			  "cd /opt/"
      ]
    }
}