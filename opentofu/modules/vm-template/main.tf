resource "proxmox_virtual_environment_vm" "this" {
  name          = var.vm_name
  description   = var.description
  tags          = distinct(concat(["opentofu"], var.tags))
  node_name     = var.node_name
  vm_id         = var.vm_id
  template      = true
  started       = false
  on_boot       = false
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
  }

  memory {
    dedicated = var.memory_mb
  }


  network_device {
    bridge  = var.network_bridge
    model   = var.network_model
    vlan_id = var.vlan_id
  }

  # Primary disk
  dynamic "disk" {
    for_each = var.disk_size_gb != null ? [var.disk_size_gb] : []
    content {
      datastore_id = var.disk_datastore
      import_from  = var.cloud_image_file_id
      interface    = var.disk_interface
      size         = disk.value
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

  initialization {
    datastore_id      = var.disk_datastore
    interface         = "scsi2"
    user_data_file_id = var.user_data_file_id

    dynamic "user_account" {
      for_each = var.user_data_file_id == null && length(var.ssh_public_keys) > 0 ? [1] : []
      content {
        username = var.username
        keys     = var.ssh_public_keys
      }
    }

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
