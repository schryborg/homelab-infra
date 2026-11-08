resource "proxmox_virtual_environment_container" "this" {
  description  = var.description
  tags         = distinct(concat(["opentofu"], var.tags))
  node_name    = var.node_name
  vm_id        = var.vm_id
  unprivileged = var.unprivileged
  template     = false

  operating_system {
    template_file_id = var.os_template_file_id
    type             = var.os_type
  }

  cpu {
    architecture = var.cpu_architecture
    cores        = var.cpu_cores
  }

  dynamic "features" {
    for_each = var.features != null ? [1] : []
    content {
      nesting = var.features.nesting
      fuse    = var.features.fuse
      keyctl  = var.features.keyctl
      mknod   = var.features.mknod
      mount   = length(var.features.mount) > 0 ? var.features.mount : null
    }
  }

  dynamic "console" {
    for_each = var.console != null ? [var.console] : []
    content {
      enabled   = console.value.enabled
      tty_count = console.value.tty_count
      type      = console.value.type
    }
  }

  memory {
    dedicated = var.memory_mb
    swap      = var.swap_mb
  }

  disk {
    datastore_id = var.disk_datastore
    size         = var.disk_size_gb
  }

  network_interface {
    name     = var.network_name
    bridge   = var.network_bridge
    vlan_id  = var.vlan_id
    firewall = var.network_firewall
  }

  dynamic "device_passthrough" {
    for_each = var.devices
    content {
      path       = device_passthrough.value.path
      gid        = device_passthrough.value.gid
      uid        = device_passthrough.value.uid
      mode       = device_passthrough.value.mode
      deny_write = device_passthrough.value.deny_write
    }
  }

  dynamic "mount_point" {
    for_each = var.mount_points
    content {
      volume        = mount_point.value.volume
      path          = mount_point.value.path
      read_only     = mount_point.value.read_only
      shared        = mount_point.value.shared
      mount_options = mount_point.value.mount_options
    }
  }

  initialization {
    hostname = var.container_name

    dns {
      domain  = var.dns_domain
      servers = var.dns_servers
    }

    dynamic "ip_config" {
      for_each = var.ip_address != null ? [1] : []
      content {
        ipv4 {
          address = var.ip_address
          gateway = var.gateway
        }
      }
    }

    dynamic "user_account" {
      for_each = length(var.ssh_public_keys) > 0 || var.root_password != null ? [1] : []
      content {
        keys     = var.ssh_public_keys
        password = var.root_password
      }
    }
  }

  started       = var.started
  start_on_boot = var.start_on_boot

  lifecycle {
    ignore_changes = [operating_system, mount_point] #todo: manage mount_points
  }
}
