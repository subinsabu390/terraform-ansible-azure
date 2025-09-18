locals {
  instances = [
    for i in range(var.instance_count) : {
      index = i
      port  = var.port_start + i + 1
    }
  ]
}


resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    lb_ip             = var.lb_ip
    instances         = local.instances
    ansible_user      = var.ansible_user
    private_key_path  = var.ansible_private_key_path
  })

  filename = "${path.module}/../../../ansible/inventory.ini"
}
