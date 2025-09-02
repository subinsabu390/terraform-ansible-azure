resource "azurerm_lb" "lb" {
    name = var.lb_name
    location = var.lb_location
    resource_group_name = var.rg_name
    sku = "Standard"

    frontend_ip_configuration {
        name = "lb_frontend"
        public_ip_address_id = var.public_ip_address_id
    }
}

resource "azurerm_lb_backend_address_pool" "address_pool" {
    name = "backend_pool"
    loadbalancer_id = azurerm_lb.lb.id
}