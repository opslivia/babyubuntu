# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.14.9"

backend "remote" {
  organization = "AZproviders"
  workspaces {
    name = "babyubuntu"
    }
  } 
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "babyubuntu-rg"
  location = "westus2"
}

resource "azurerm_virtual_network" "main" {
  name                = "babyubuntu-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "babyubuntu-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "babyubuntu-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "babyubuntu-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "babyubuntu-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B1s"
  admin_username      = "oliviac"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = "oliviac"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  
  data "azurerm_ssh_public_key" "main" {
  name                = "babyubuntu-sshkey"
  resource_group_name = azurerm_resource_group.main.name
}

output "id" {
  value = data.azurerm_ssh_public_key.main.id
}
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuPro"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
