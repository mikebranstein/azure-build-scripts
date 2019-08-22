
provider "azurerm" {
    tenant_id       = "${var.tenant_id}"
    subscription_id = "${var.subscription_id}" 
}

resource "azurerm_resource_group" "rg" {
    name = "tf-az-workshop-rg"
    location = "East US"
}