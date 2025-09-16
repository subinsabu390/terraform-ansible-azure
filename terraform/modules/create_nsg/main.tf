resource "azurerm_network_security_group" "nsg" {
    name                = var.nsg_name
    location            = var.nsg_location
    resource_group_name = var.rg_name

    security_rule {
      name                       = var.rule_name
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = var.source_address_prefix
      destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "sg-asso" {
    subnet_id = var.subnet_id
    network_security_group_id = azurerm_network_security_group.nsg.id
  
    depends_on = [
      azurerm_network_security_group.nsg
    ]
}