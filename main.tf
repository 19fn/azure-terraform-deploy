# Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name = "virtualNetwork"
    address_space = ["10.0.0.0/16"]
    location = var.resource_group_location
    resource_group_name = var.resource_group_name
}

# Create subnet
resource "azurerm_subnet" "subnet_1" {
    name = "Subnet1"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.1.0/24"]    
}

# Create public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "publicIP"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "networkSecurityGroup"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  # SSH
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # HTTP
  security_rule {
    name                       = "WEBSITE"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # MYSQL
  security_rule {
    name                       = "DATABASE"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "networkInterface"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "NICconf"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "assoc_nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create an SSH key
resource "tls_private_key" "key_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "LogisticaSur-Server"
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "vm_disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = var.computer_name
  admin_username                  = var.admin_user
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_user
    public_key = tls_private_key.key_ssh.public_key_openssh
  }

  # Remote connection
  connection {
    type = "ssh"
    host = self.public_ip_address
    user = var.admin_user
    private_key = tls_private_key.key_ssh.private_key_openssh
    timeout = "5m"
  }

    provisioner "remote-exec" {
       inline = [
                	"sudo apt-get update",
                        "cd /opt && sudo git clone https://github.com/19fn/docker-pack.git",
			"sudo /bin/bash /opt/docker_install.sh/install.sh",
			"cd /opt && sudo git clone https://github.com/19fn/flask-web-app.git",
			"cd /opt/flask-web-app && sudo /bin/bash initialize.sh"
                ]
        }
}
