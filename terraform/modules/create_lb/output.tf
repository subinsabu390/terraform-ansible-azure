output "lb_backend_address_pool_id" {
    value = azurerm_lb_backend_address_pool.address_pool.id
}

output "frontend_port_start" {
  value = azurerm_lb_nat_rule.nat_rules.frontend_port_start
}
