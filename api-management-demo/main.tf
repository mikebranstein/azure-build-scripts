variable "tenant_id" { }
variable "subscription_id" { }
variable "base_name" { default = "api-mgmt-demo" }

resource "random_integer" "ri" {
    min = 10000
    max = 99999
}

locals {
    unique_name = "${var.base_name}${random_integer.ri.result}"
}


provider "azurerm" {
    tenant_id       = "${var.tenant_id}"
    subscription_id = "${var.subscription_id}" 
    use_msi         = true
}

resource "azurerm_resource_group" "rg" {
    name = "tf-az-${local.unique_name}-rg"
    location = "East US"
}

# App Service Plan
resource "azurerm_app_service_plan" "standard_app_plan" {
    name                = "tf-az-standard-${local.unique_name}-plan"
    location            = "East US"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    sku {
        tier = "Basic"
        size = "B1"
    }
}

# App Service
resource "azurerm_app_service" "app1_app_service" {
    name                = "tf-az-${local.unique_name}-app"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    app_service_plan_id = "${azurerm_app_service_plan.standard_app_plan.id}"
}