variable "tenant_id" { }
variable "subscription_id" { }
variable "resource_group_name" { }
variable "location" { default = "East US" }
variable "vm_base_name" { default = "workshop" }

provider "azurerm" {
    tenant_id                   = "${var.tenant_id}"
    subscription_id             = "${var.subscription_id}" 
    use_msi                     = true
    skip_provider_registration  = true
}

locals {
    random_hash = substr(md5(var.resource_group_name), 0, 5)
}

data "azurerm_resource_group" "rg" {
  name = "${var.resource_group_name}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "tf-az-${var.vm_base_name}-nvet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.0.0/24"
}

resource "azurerm_network_interface" "nic" {
  name                = "tf-az-${var.vm_base_name}-vm-nic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "tf-az-${var.vm_base_name}-vm-nic-ip-config"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pip.id}"
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "tf-az-${var.vm_base_name}-vm-pip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "tf-az-${var.vm_base_name}-vm"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_DS4_v2"

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
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "ra_contrib" {
  scope                = "${data.azurerm_resource_group.rg.id}"
  role_definition_name = "Contributor"
  principal_id         = "${azurerm_virtual_machine.vm.identity.0.principal_id}"
}

resource "azurerm_role_assignment" "ra_sa_contrib" {
  scope                = "${data.azurerm_resource_group.rg.id}"
  role_definition_name = "Storage Account Contributor"
  principal_id         = "${azurerm_virtual_machine.vm.identity.0.principal_id}"
}

resource "azurerm_virtual_machine_extension" "ext_install_prereqs" {
  name                 = "tf-az-install-prereqs-vm-ext"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_machine_name = "${azurerm_virtual_machine.vm.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  # CustomVMExtension Documetnation: https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows

  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/mikebranstein/azure-build-scripts/master/devops-in-a-day-workshop/Install-Prereqs.ps1"]
    }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File Install-Prereqs.ps1"
    }
PROTECTED_SETTINGS
  depends_on = ["azurerm_virtual_machine.vm"]
}
