resource "proxmox_backup_job" "daily_backup" {
  id       = "backup-bb3c774b-b0b2"
  schedule = "4:00"
  storage  = "pbs"
  notes_template = "{{guestname}}"
  fleecing = {
    enabled = false
  }
  # all      = false
  mode     = "snapshot"
  compress = "zstd"
  prune_backups = {
    keep-last = "7",
    keep-monthly = "1"
  }
  vmid = [
    module.vm["docker"].vm_id,
    module.vm["docker2"].vm_id,
    module.vm["docker3"].vm_id,
    module.vm["opnsense"].vm_id,
    module.vm["k3s-master1"].vm_id,
    module.vm["k3s-master2"].vm_id,
    module.vm["k3s-master3"].vm_id,
    module.vm["k3s-worker1"].vm_id,
    module.vm["k3s-worker2"].vm_id,
    module.vm["k3s-worker3"].vm_id,
    module.lxc["jellyfin"].vm_id,
    module.lxc["forgejo"].vm_id,
    module.lxc["postgres"].vm_id,
    module.lxc["tdarr-server"].vm_id,
    module.lxc["unifi-network"].vm_id,
    module.lxc["hermes"].vm_id,
    module.lxc["netbird-gateway"].vm_id,
    module.lxc["pangolin-gateway"].vm_id,
    module.lxc["technitium1"].vm_id,
    module.lxc["technitium2"].vm_id,
    module.lxc["caddy"].vm_id
  ]
}

import {
  id = "backup-bb3c774b-b0b2"
  to = proxmox_backup_job.daily_backup
}

