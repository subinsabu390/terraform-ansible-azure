output "lb_ip" {
    value = azurerm_public_ip.lb_ip.id
}

output "ip_address" {
    value = azurerm_public_ip.lb_ip.ip_address
}