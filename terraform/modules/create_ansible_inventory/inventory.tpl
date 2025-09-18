[vmss]
%{ for item in instances ~}
vm-${item.index} ansible_host=${lb_ip} ansible_port=${item.port} ansible_user=${ansible_user} ansible_ssh_private_key_file=${private_key_path}
%{ endfor ~}
