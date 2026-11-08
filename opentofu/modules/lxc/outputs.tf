output "vm_id" {
  description = "Assigned Proxmox container ID"
  value       = proxmox_virtual_environment_container.this.vm_id
}

output "name" {
  description = "Container hostname"
  value       = var.container_name
}

output "node_name" {
  description = "Proxmox node hosting the container"
  value       = proxmox_virtual_environment_container.this.node_name
}

output "ipv4" {
  description = "IPv4 addresses reported by the container, keyed by network interface"
  value       = proxmox_virtual_environment_container.this.ipv4
}

output "started" {
  description = "Whether the container is running"
  value       = proxmox_virtual_environment_container.this.started
}
