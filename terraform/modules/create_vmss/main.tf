resource "tls_private_key" "vmss_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "azurerm_key_vault_secret" "private_key" {
    name = var.kv_secret_name
    key_vault_id = var.key_vault_id
    value = tls_private_key.vmss_key.private_key_pem
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
    name = var.vmss_name
    location = var.vmss_location
    resource_group_name = var.rg_name
    sku = var.machine_size
    instances = var.instances_number
    admin_username = var.admin_username
    # admin_password = var.admin_password

    admin_ssh_key {
      username = var.admin_username
      public_key = tls_private_key.vmss_key.public_key_openssh
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
      
    }

    network_interface {
        name = var.nic_name
        primary = true
        
        
        ip_configuration {
            name = "internal"
            primary = true
            subnet_id = var.subnet_id
            load_balancer_backend_address_pool_ids = var.load_balancer_backend_address_pool_ids
        }
    }
}