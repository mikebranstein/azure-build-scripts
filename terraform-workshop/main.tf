variable "tenant_id" { }
variable "subscription_id" { }



provider "azurerm" {
    tenant_id       = "${var.tenant_id}"
    subscription_id = "${var.subscription_id}" 
    use_msi         = true
}

resource "azurerm_resource_group" "rg" {
    name = "tf-az-workshop-rg"
    location = "East US"
}

locals {
    random_hash = substr(md5(azurerm_resource_group.rg.id), 0, 5)
}

resource "azurerm_storage_account" "testsa" {
  name                     = "workshopsa${local.random_hash}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}