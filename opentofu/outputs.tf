output "proxmox_version" {
  value = data.proxmox_version.version.version
}

output "proxmox_node_names" {
  value = data.proxmox_virtual_environment_nodes.nodes.names
}


