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