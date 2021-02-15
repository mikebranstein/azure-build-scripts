terraform {
  required_version = "~>0.14"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.43"
    }
  }
}

provider "azurerm" {
  features {}
  tenant_id                 = var.tenant_id
  subscription_id           = var.subscription_id
  use_msi                     = true
  skip_provider_registration  = true
}

variable "tenant_id" { }
variable "subscription_id" { }
variable "vm_base_name" { default = "workshop" }

locals {
  random_hash = substr(md5(azurerm_resource_group.rg.id), 0, 5)
}

resource "azurerm_resource_group" "rg" {
  name = "tf-az-${var.vm_base_name}-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "tf-az-${var.vm_base_name}-nvet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "tf-az-${var.vm_base_name}-vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "tf-az-${var.vm_base_name}-vm-nic-ip-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "tf-az-${var.vm_base_name}-vm-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "tf-az-${var.vm_base_name}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS4_v3"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "tfaz${var.vm_base_name}vmdisk01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }
  os_profile {
    computer_name  = "${var.vm_base_name}-vm"
    admin_username = "workshopadmin"
    admin_password = "P.$$w0rd1234"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
}

resource "azurerm_virtual_machine_extension" "ext_install_prereqs" {
  name                 = "tf-az-install-prereqs-vm-ext"
  virtual_machine_id   = azurerm_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  # CustomVMExtension Documentation: https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows

  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/mikebranstein/azure-build-scripts/master/terraform-workshop/Install-Prereqs.ps1"]
    }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File Install-Prereqs.ps1"
    }
PROTECTED_SETTINGS
}
