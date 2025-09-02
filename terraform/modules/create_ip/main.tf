resource "azurerm_public_ip" "lb_ip" {
    name = var.lb_ip_name
    location = var.lb_ip_location
    resource_group_name = var.rg_name
    allocation_method = "Static"
    sku = "Standard"
}