output "subnet_id" {
    value = azurerm_subnet.subnet.id
}

output "subnet_name" {
    value = azurerm_subnet.subnet.name
}

output "vnet_name" {
    value = azurerm_virtual_network.vnet.name
}