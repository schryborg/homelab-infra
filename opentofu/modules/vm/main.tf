resource "proxmox_virtual_environment_file" "meta_data" {
  count        = var.cloud_init_enabled ? 1 : 0
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name

  source_raw {
    data = <<-EOF
instance-id: ${var.vm_name}
local-hostname: ${var.vm_name}
EOF

    file_name = "${var.vm_name}-meta-data.yaml"
  }

  lifecycle {
    ignore_changes = [source_raw[0].data]
  }
}

resource "proxmox_virtual_environment_file" "user_data" {
  count        = var.cloud_init_enabled ? 1 : 0
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name

  source_raw {
    data = <<-EOF
#cloud-config
hostname: ${var.vm_name}
fqdn: ${var.vm_name}
%{if var.username != null~}
users:
  - name: ${var.username}
    shell: /bin/bash
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    ssh_authorized_keys:
%{for k in var.ssh_public_keys~}
      - ${k}
%{endfor~}
%{endif~}
package_update: true
packages:
  - qemu-guest-agent
runcmd:
  - systemctl enable --now qemu-guest-agent
EOF

    file_name = "${var.vm_name}-user-data.yaml"
  }

  lifecycle {
    ignore_changes = [source_raw[0].data]
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name          = var.vm_name
  description   = var.description
  tags          = distinct(concat(["opentofu"], var.tags))
  node_name     = var.node_name
  vm_id         = var.vm_id
  template      = false
  bios          = var.bios
  machine       = var.machine
  scsi_hardware = var.scsi_hardware

  operating_system {
    type = var.operating_system
  }

  agent {
    enabled = var.agent_enabled
  }

  cpu {
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    type    = var.cpu_type
    flags   = var.cpu_flags
  }

  memory {
    dedicated = var.memory_mb
    floating  = var.balloon_mb
  }

  dynamic "clone" {
    for_each = var.template_vm_id != null ? [var.template_vm_id] : []
    content {
      vm_id        = var.template_vm_id
      node_name    = var.template_node_name
      datastore_id = var.disk_datastore
      full         = var.full_clone
    }
  }

  dynamic "network_device" {
    for_each = var.network_devices
    content {
      bridge   = network_device.value.network_bridge
      model    = network_device.value.network_model
      firewall = network_device.value.firewall
      vlan_id  = network_device.value.vlan_id
      queues   = network_device.value.queues
    }
  }

  # network_device {
  #   bridge   = var.network_bridge
  #   model    = var.network_model
  #   firewall = var.network_firewall
  #   vlan_id  = var.vlan_id
  # }

  started = var.started
  on_boot = var.start_on_boot

  # Primary disk
  dynamic "disk" {
    for_each = var.disk_size_gb != null ? [var.disk_size_gb] : []
    content {
      datastore_id = var.disk_datastore
      interface    = var.disk_interface
      size         = disk.value
      iothread     = true
      discard      = "on"
      ssd          = var.disk_ssd
    }
  }

  # Extra disks
  dynamic "disk" {
    for_each = var.extra_disks
    content {
      datastore_id = disk.value.datastore_id
      interface    = disk.value.interface
      size         = disk.value.size
      iothread     = true
      discard      = "on"
      ssd          = var.disk_ssd
    }
  }

  # EFI disk
  dynamic "efi_disk" {
    for_each = var.bios == "ovmf" ? [1] : []
    content {
      datastore_id      = var.disk_datastore
      type              = var.efi_disk_type
      pre_enrolled_keys = var.efi_disk_pre_enrolled_keys
    }
  }

  dynamic "initialization" {
    for_each = var.cloud_init_enabled ? [1] : []
    content {
      datastore_id      = var.disk_datastore
      interface         = "scsi2"
      user_data_file_id = proxmox_virtual_environment_file.user_data[0].id
      meta_data_file_id = proxmox_virtual_environment_file.meta_data[0].id

      dns {
        domain  = var.dns_domain
        servers = var.dns_servers
      }

      ip_config {
        ipv4 {
          address = var.ip_address
          gateway = var.gateway
        }
      }
    }
  }
}
