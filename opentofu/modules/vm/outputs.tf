output "vm_id" {
  description = "Assigned Proxmox VM ID"
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  description = "VM name"
  value       = proxmox_virtual_environment_vm.this.name
}

output "node_name" {
  description = "Proxmox node hosting the VM"
  value       = proxmox_virtual_environment_vm.this.node_name
}

output "ipv4_addresses" {
  description = "IPv4 addresses reported by the QEMU guest agent"
  value       = proxmox_virtual_environment_vm.this.ipv4_addresses
}

output "mac_addresses" {
  description = "MAC addresses of the VM network devices"
  value       = proxmox_virtual_environment_vm.this.mac_addresses
}

output "started" {
  description = "Whether the VM is running"
  value       = proxmox_virtual_environment_vm.this.started
}
