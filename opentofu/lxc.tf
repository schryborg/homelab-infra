locals {
  lxc = {
    netbird-gateway = {
      node_name    = "pve01"
      cpu_cores    = 2
      memory_mb    = 1024
      swap_mb      = 512
      disk_size_gb = 8
      ip_address   = "192.168.50.8/24"
      features = {
        nesting = true
      }
    }
    pangolin-gateway = {
      node_name    = "pve01"
      cpu_cores    = 2
      memory_mb    = 1024
      swap_mb      = 512
      disk_size_gb = 8
      ip_address   = "192.168.50.9/24"
      features = {
        nesting = true
      }
    }
    forgejo = {
      node_name    = "pve03"
      cpu_cores    = 2
      memory_mb    = 512
      swap_mb      = 512
      disk_size_gb = 10
      ip_address   = "192.168.50.22/24"
      features = {
        nesting = true
      }
    }
    technitium1 = {
      node_name    = "pve02"
      cpu_cores    = 2
      memory_mb    = 512
      swap_mb      = 512
      disk_size_gb = 10
      ip_address   = "192.168.50.30/24"
      features = {
        nesting = true
      }
    }
    technitium2 = {
      node_name    = "pve03"
      cpu_cores    = 2
      memory_mb    = 512
      swap_mb      = 512
      disk_size_gb = 10
      ip_address   = "192.168.50.31/24"
      features = {
        nesting = true
      }
    }

    # Imported LXCs: brought under OpenTofu management via import.tf.
    # ssh_public_keys must stay empty to avoid forcing recreation.
    jellyfin = {
      vm_id        = 102
      node_name    = "pve01"
      import_id    = "pve01/102"
      cpu_cores    = 4
      memory_mb    = 4096
      swap_mb      = 512
      disk_size_gb = 20
      ip_address   = "192.168.50.48/24"
      features = {
        nesting = true
      }
      devices = [
        {
          path = "/dev/dri/renderD128"
          gid  = 104
        }
      ]
      ssh_public_keys = []
    }
    tdarr-node1 = {
      vm_id        = 104
      node_name    = "pve01"
      import_id    = "pve01/104"
      cpu_cores    = 4
      memory_mb    = 4096
      swap_mb      = 512
      disk_size_gb = 50
      ip_address   = "192.168.50.46/24"
      features = {
        nesting = true
      }
      devices = [
        {
          path = "/dev/dri/renderD128"
          gid  = 104
        }
      ]
      network_firewall = true
      ssh_public_keys  = []
    }
    postgres = {
      vm_id        = 107
      node_name    = "pve02"
      import_id    = "pve02/107"
      cpu_cores    = 4
      memory_mb    = 4096
      swap_mb      = 512
      disk_size_gb = 20
      ip_address   = "192.168.50.69/24"
      features = {
        nesting = true
      }
      ssh_public_keys  = []
    }
    tdarr-server = {
      vm_id        = 202
      node_name    = "pve02"
      import_id    = "pve02/202"
      cpu_cores    = 4
      memory_mb    = 4096
      swap_mb      = 512
      disk_size_gb = 50
      ip_address   = "192.168.50.45/24"
      features = {
        nesting = true
      }
      devices = [
        {
          path = "/dev/dri/renderD128"
          gid  = 104
        }
      ]
      network_firewall = true
      ssh_public_keys  = []
    }
    unifi-network = {
      vm_id        = 204
      node_name    = "pve02"
      import_id    = "pve02/204"
      cpu_cores    = 2
      memory_mb    = 2048
      swap_mb      = 512
      disk_size_gb = 8
      ip_address   = "192.168.50.7/24"
      features = {
        nesting = true
      }
      ssh_public_keys  = []
    }
    gitea = {
      vm_id        = 301
      node_name    = "pve03"
      import_id    = "pve03/301"
      cpu_cores    = 2
      memory_mb    = 512
      swap_mb      = 512
      disk_size_gb = 8
      ip_address   = "192.168.50.21/24"
      features = {
        nesting = true
      }
      network_firewall = true
      ssh_public_keys  = []
    }
    tdarr-node2 = {
      vm_id        = 302
      node_name    = "pve03"
      import_id    = "pve03/302"
      cpu_cores    = 4
      memory_mb    = 4096
      swap_mb      = 512
      disk_size_gb = 50
      ip_address   = "192.168.50.47/24"
      features = {
        nesting = true
      }
      devices = [
        {
          path = "/dev/dri/renderD128"
          gid  = 104
        }
      ]
      network_firewall = true
      ssh_public_keys  = []
    }
    caddy = {
      vm_id        = 305
      node_name    = "pve03"
      import_id    = "pve03/305"
      cpu_cores    = 2
      memory_mb    = 1024
      swap_mb      = 512
      disk_size_gb = 8
      ip_address   = "192.168.50.5/24"
      features = {
        nesting = true
      }
      network_firewall = true
      ssh_public_keys  = []
    }
    hermes = {
      node_name    = "pve03"
      cpu_cores    = 2
      memory_mb    = 2048
      swap_mb      = 512
      disk_size_gb = 20
      ip_address   = "192.168.50.18/24"
      features = {
        nesting = true
      }
    }
  }
}

module "lxc" {
  source   = "./modules/lxc/"
  for_each = local.lxc

  container_name = each.key
  node_name      = each.value.node_name
  vm_id          = lookup(each.value, "vm_id", null)
  tags           = lookup(each.value, "tags", [])

  cpu_cores    = each.value.cpu_cores
  memory_mb    = each.value.memory_mb
  swap_mb      = each.value.swap_mb
  disk_size_gb = each.value.disk_size_gb

  features         = lookup(each.value, "features", null)
  devices          = lookup(each.value, "devices", [])
  mount_points     = lookup(each.value, "mount_points", [])
  network_firewall = lookup(each.value, "network_firewall", false)

  ip_address      = each.value.ip_address
  gateway         = lookup(each.value, "gateway", "192.168.50.1")
  vlan_id         = lookup(each.value, "vlan_id", 50)
  dns_domain      = lookup(each.value, "dns_domain", "internal.schryborg.de")
  ssh_public_keys = lookup(each.value, "ssh_public_keys", local.ssh_public_keys)

  os_template_file_id = proxmox_download_file.debian_12_template[each.value.node_name].id
}

resource "proxmox_download_file" "debian_12_template" {
  for_each     = toset(["pve01", "pve02", "pve03"])
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = each.value
  url          = "http://download.proxmox.com/images/system/debian-12-standard_12.12-1_amd64.tar.zst"
  file_name    = "debian-12-standard_12.12-1_amd64.tar.zst"
}
