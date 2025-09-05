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

resource "azurerm_lb_nat_rule" "nat_rules" {
    name = var.nat_rule_name
    resource_group_name = var.rg_name
    backend_port = 22
    loadbalancer_id = azurerm_lb.lb.id
    protocol = "Tcp"
    frontend_port_start = 50000
    frontend_port_end  = 50020
    backend_address_pool_id = azurerm_lb_backend_address_pool.address_pool.id
    frontend_ip_configuration_name = "lb_frontend"
}