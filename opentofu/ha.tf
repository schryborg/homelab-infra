locals {
  hagroups = {
    prio123 = {
      nodes = {
        pve01 = 3, pve02 = 2, pve03 = 1
      },
      hosts = [
        { type = "vm", name = "docker" },
        { type = "ct", name = "jellyfin" }
      ]
    },
    prio132 = {
      nodes = {
        pve01 = 3, pve02 = 1, pve03 = 2
      },
      hosts = [
        { type = "ct", name = "netbird-gateway" },
        { type = "ct", name = "pangolin-gateway" }
      ]
    },
    prio213 = {
      nodes = {
        pve01 = 2, pve02 = 3, pve03 = 1
      },
      hosts = [
        { type = "vm", name = "docker2" },
        { type = "ct", name = "unifi-network" }
      ]
    },
    prio231 = {
      nodes = {
        pve01 = 1, pve02 = 3, pve03 = 2
      },
      hosts = [
        { type = "ct", name = "postgres" }
      ]
    },
    prio312 = {
      nodes = {
        pve01 = 2, pve02 = 1, pve03 = 3
      },
      hosts = [
        { type = "vm", name = "docker3" },
        { type = "ct", name = "forgejo" }
      ]
    },
    prio321 = {
      nodes = {
        pve01 = 1, pve02 = 2, pve03 = 3
      },
      hosts = [
        { type = "ct", name = "hermes" },
        { type = "ct", name = "caddy" }
      ]
    },
  }

  ha_resources = merge([
    for group_name, group in local.hagroups : {
      for host in group.hosts : "${group_name}-${host.name}" => {
        group = group_name
        type  = host.type
        name  = host.name
      }
    }
  ]...)
}

resource "proxmox_hagroup" "hagroups" {
  for_each = local.hagroups

  group   = each.key
  comment = "Created by OpenTofu."
  nodes   = each.value.nodes

  restricted  = false
  no_failback = false
}

resource "proxmox_haresource" "haresources" {
  for_each = local.ha_resources

  depends_on = [
    proxmox_hagroup.hagroups
  ]

  resource_id    = each.value.type == "vm" ? "vm:${module.vm[each.value.name].vm_id}" : "ct:${module.lxc[each.value.name].vm_id}"
  state          = "started"
  group          = each.value.group
  comment        = "Managed by OpenTofu"
  # failback       = true
  # auto_rebalance = true
  max_relocate   = 2
}
