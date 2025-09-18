module "create_rg" {
    source = "./modules/create_rg"
    rg_name = var.rg_name
    rg_location = var.rg_location
}

module "create_kv" {
    source = "./modules/create_kv"
    rg_name = var.rg_name
    rg_location = var.rg_location
    key_vault_name = var.key_vault_name

    depends_on = [ module.create_rg ]
}


module "create_vnet" {
    source = "./modules/create_vnet"
    vnet_name = var.vnet_name
    vnet_location = module.create_rg.rg_location
    rg_name = module.create_rg.rg_name
    subnet_name = var.subnet_name

    depends_on = [ module.create_kv ]
}

module "create_ip" {
    source = "./modules/create_ip"
    lb_ip_name = var.lb_ip_name
    lb_ip_location = module.create_rg.rg_location
    rg_name = var.rg_name

    depends_on = [ module.create_vnet ]
}

module "create_lb" {
    source = "./modules/create_lb"
    lb_name = var.lb_name
    lb_location = module.create_rg.rg_location
    rg_name = module.create_rg.rg_name
    public_ip_address_id = module.create_ip.lb_ip
    nat_rule_name = var.nat_rule_name

    depends_on = [ module.create_ip ]
}

module "create_vmss" {
    source = "./modules/create_vmss"
    rg_name = module.create_rg.rg_name
    vmss_name = var.vmss_name
    vnet_name = module.create_vnet.vnet_name
    machine_size = var.machine_size
    load_balancer_backend_address_pool_ids = [module.create_lb.lb_backend_address_pool_id]
    admin_username = var.admin_username
    nic_name = var.nic_name
    vnet_location = module.create_rg.rg_location
    vmss_location = module.create_rg.rg_location
    instances_number = var.instances_number
    subnet_name = module.create_vnet.subnet_name
    subnet_id = module.create_vnet.subnet_id
    key_vault_id = module.create_kv.key_vault_id
    kv_secret_name = var.kv_secret_name

    depends_on = [ module.create_lb ]
}

module "create_nsg" {
    source = "./modules/create_nsg"
    rg_name = module.create_rg.rg_name
    nsg_name = var.nsg_name
    nsg_location = module.create_rg.rg_location
    source_address_prefix = var.source_address_prefix
    subnet_id = module.create_vnet.subnet_id
    rule_name = var.rule_name 

    depends_on = [ module.create_vnet ]
}

module "create_ansible_inventory" {
    source = "./modules/create_ansible_inventory"
    port_start = module.create_lb.frontend_port_start
    lb_ip = module.create_ip.ip_address
    instance_count = var.instances_number
    ansible_user = var.admin_username
    ansible_private_key_path = var.ansible_private_key_path

    depends_on = [ module.create_vmss ]
}