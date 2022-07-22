# resource "azurerm_app_service_plan" "plan" {
#   name                    = "${var.app_name}-premiumPlan"
#   resource_group_name     = "${data.azurerm_resource_group.rg.name}"
#   location                = "${data.azurerm_resource_group.rg.location}"
#   kind                    = "Linux"
#   reserved                = true

#   sku {
#     tier = "Premium"
#     size = "P1V2"
#   }
# }

# resource "azurerm_function_app" "funcApp" {
#     name                       = "userapi-${var.app_name}fa-${var.env_name}"
#     location                   = "${data.azurerm_resource_group.rg.location}"
#     resource_group_name        = "${data.azurerm_resource_group.rg.name}"
#     app_service_plan_id        = "${azurerm_app_service_plan.plan.id}"
#     storage_connection_string  = "${azurerm_storage_account.storage.primary_connection_string}"
#     version                    = "~2"

#     app_settings = {
#         FUNCTION_APP_EDIT_MODE                    = "readOnly"
#         https_only                                = true
#         DOCKER_REGISTRY_SERVER_URL                = "${data.azurerm_container_registry.registry.login_server}"
#         DOCKER_REGISTRY_SERVER_USERNAME           = "${data.azurerm_container_registry.registry.admin_username}"
#         DOCKER_REGISTRY_SERVER_PASSWORD           = "${data.azurerm_container_registry.registry.admin_password}"
#         WEBSITES_ENABLE_APP_SERVICE_STORAGE       = false
#     }

#     site_config {
#       always_on         = true
#       linux_fx_version  = "DOCKER|${data.azurerm_container_registry.registry.login_server}/${var.image_name}:${var.tag}"
#     }
# }