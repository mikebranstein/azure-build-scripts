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
resource "azurerm_app_service" "app" {
    name                = "tf-az-${local.unique_name}-app"
    location            = "East US"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    app_service_plan_id = "${azurerm_app_service_plan.standard_app_plan.id}"

    app_settings = {
        "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    }
}

# resource "null_resource" "enable_compilation" {
#     provisioner "local-exec" {
#         command = "az webapp config appsettings set --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_app_service.app.name} --settings SCM_DO_BUILD_DURING_DEPLOYMENT=true"
#     }

#     depends_on = [azurerm_app_service.app]
# }

resource "null_resource" "deploy_app" {
    provisioner "local-exec" {
        command = "az webapp deployment source config-zip --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_app_service.app.name} --src app.zip"
    }

    depends_on = [azurerm_app_service.app]
}


# API Management
# resource "azurerm_api_management" "apim" {
#     name                = "tf-az-${local.unique_name}-apim"
#     location            = "East US"
#     resource_group_name = "${azurerm_resource_group.rg.name}"
#     publisher_name      = "Contoso"
#     publisher_email     = "contoso@microsoft.com"

#     sku {
#         name     = "Standard"
#         capacity = 1
#     }
# }

