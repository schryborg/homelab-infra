locals {
  default_template_vm_id = {
    pve01 = module.debian_template_pve01.vm_id
    pve02 = module.debian_template_pve02.vm_id
    pve03 = module.debian_template_pve03.vm_id
  }

  vms = {
    # Imported Docker hosts
    docker = {
      vm_id              = 100
      node_name          = "pve01"
      import_id          = "pve01/100"
      cpu_cores          = 4
      memory_mb          = 8192
      balloon_mb         = 0
      disk_size_gb       = 100
      efi_disk_type      = "4m"
      ip_address         = "192.168.50.40/24"
      cloud_init_enabled = false
      username           = null
      ssh_public_keys    = []
      template_vm_id     = null
      dns_domain         = null
    }
    docker2 = {
      vm_id              = 109
      node_name          = "pve02"
      import_id          = "pve02/109"
      cpu_cores          = 4
      memory_mb          = 4096
      balloon_mb         = 0
      disk_size_gb       = 500
      efi_disk_type      = "4m"
      ip_address         = "192.168.50.41/24"
      cloud_init_enabled = false
      username           = null
      ssh_public_keys    = []
      template_vm_id     = null
      dns_domain         = null
    }
    docker3 = {
      vm_id              = 304
      node_name          = "pve03"
      import_id          = "pve03/304"
      cpu_cores          = 2
      memory_mb          = 2048
      balloon_mb         = 0
      disk_size_gb       = 32
      efi_disk_type      = "4m"
      ip_address         = "192.168.50.42/24"
      cloud_init_enabled = false
      username           = null
      ssh_public_keys    = []
      template_vm_id     = null
      dns_domain         = null
    }
    opnsense = {
      vm_id              = 307
      node_name          = "pve03"
      import_id          = "pve03/307"
      bios               = "seabios"
      machine            = "pc"
      cpu_type           = "x86-64-v2-AES"
      cpu_cores          = 4
      cpu_flags          = ["+aes"]
      memory_mb          = 4096
      balloon_mb         = 0
      disk_size_gb       = 40
      network_devices    = [
        {
          network_bridge = "vmbr1",
          network_model  = "virtio",
          vlan_id        = null,
          firewall       = false
          queues         = 4
        },
        {
          network_bridge = "vmbr2",
          network_model  = "virtio",
          vlan_id        = null,
          firewall       = false
          queues         = 4
        }
      ]
      ip_address         = "192.168.1.1/24"
      cloud_init_enabled = false
      username           = null
      ssh_public_keys    = []
      template_vm_id     = null
      dns_domain         = null
    }
    # k3s control plane
    k3s-master1 = {
      node_name     = "pve01"
      cpu_cores     = 2
      memory_mb     = 2028
      ip_address    = "192.168.50.81/24"
      disk_size_gb  = 10
    }
    k3s-master2 = {
      node_name     = "pve02"
      cpu_cores     = 2
      memory_mb     = 2028
      ip_address    = "192.168.50.82/24"
      disk_size_gb  = 10
    }
    k3s-master3 = {
      node_name     = "pve03"
      cpu_cores     = 2
      memory_mb     = 2028
      ip_address    = "192.168.50.83/24"
      disk_size_gb  = 10
    }
    # k3s workers
    k3s-worker1 = {
      node_name     = "pve01"
      cpu_cores     = 2
      memory_mb     = 2028
      ip_address    = "192.168.50.84/24"
      disk_size_gb  = 32
      extra_disks   = [
        { size = 100, interface = "scsi1" }
      ]
    }
    k3s-worker2 = {
      node_name     = "pve02"
      cpu_cores     = 2
      memory_mb     = 2028
      ip_address    = "192.168.50.85/24"
      disk_size_gb  = 32
      extra_disks   = [
        { size = 100, interface = "scsi1" }
      ]
    }
    k3s-worker3 = {
      node_name     = "pve03"
      cpu_cores     = 2
      memory_mb     = 2048
      ip_address    = "192.168.50.86/24"
      disk_size_gb  = 32
      extra_disks   = [
        { size = 100, interface = "scsi1" }
      ]
    }
  }
}

module "vm" {
  source = "./modules/vm/"
  depends_on = [
    proxmox_hagroup.hagroups
  ]
  for_each = local.vms

  vm_name          = each.key
  node_name        = each.value.node_name
  vm_id            = lookup(each.value, "vm_id", null)
  bios             = lookup(each.value, "bios", "ovmf")
  machine          = lookup(each.value, "machine", "q35")
  cpu_type         = lookup(each.value, "cpu_type", "host")
  cpu_cores        = each.value.cpu_cores
  cpu_sockets      = lookup(each.value, "cpu_sockets", 1)
  cpu_flags        = lookup(each.value, "cpu_flags", [])
  memory_mb        = each.value.memory_mb
  balloon_mb       = lookup(each.value, "balloon_mb", each.value.memory_mb)
  disk_size_gb     = lookup(each.value, "disk_size_gb", null)
  efi_disk_type    = lookup(each.value, "efi_disk_type", "4m")
  # network_bridge   = lookup(each.value, "network_bridge", ["vmbr0"])
  # network_firewall = lookup(each.value, "network_firewall", false)
  network_devices = lookup(each.value, "network_devices", [
    {
      network_bridge = "vmbr0",
      network_model  = "virtio",
      vlan_id        = 50,
      firewall       = false
    }
  ])

  template_vm_id     = lookup(each.value, "template_vm_id", local.default_template_vm_id[each.value.node_name])
  cloud_init_enabled = lookup(each.value, "cloud_init_enabled", true)
  username           = lookup(each.value, "username", "deploy")
  ssh_public_keys    = lookup(each.value, "ssh_public_keys", local.ssh_public_keys)

  # vlan_id    = lookup(each.value, "vlan_id", 50)
  ip_address = lookup(each.value, "ip_address", null)
  dns_domain = lookup(each.value, "dns_domain", "internal.schryborg.de")
  gateway    = lookup(each.value, "gateway", "192.168.50.1")

  extra_disks = lookup(each.value, "extra_disks", [])
}

import {
  id = "pve03/307"
  to = module.vm["opnsense"].proxmox_virtual_environment_vm.this
}
