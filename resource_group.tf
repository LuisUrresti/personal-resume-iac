resource "azurerm_resource_group" "rsg" {
    name = lower("${var.project_name}-rg")
    location = var.location

    tags = var.tags
}