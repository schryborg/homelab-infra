resource "proxmox_replication" "docker-replication-1" {
  id = format("%d-0", module.vm["docker"].vm_id)
  target = "pve02"
  type   = "local"
  schedule = "*/15"
}
resource "proxmox_replication" "docker-replication-2" {
  id = format("%d-1", module.vm["docker"].vm_id)
  target = "pve03"
  type   = "local"
  schedule = "*/15"
}
resource "proxmox_replication" "docker2-replication-1" {
  id = format("%d-0", module.vm["docker2"].vm_id)
  target = "pve01"
  type   = "local"
  schedule = "*/15"
}
resource "proxmox_replication" "docker2-replication-2" {
  id = format("%d-1", module.vm["docker2"].vm_id)
  target = "pve03"
  type   = "local"
  schedule = "*/15"
}
resource "proxmox_replication" "docker3-replication-1" {
  id = format("%d-0", module.vm["docker3"].vm_id)
  target = "pve01"
  type   = "local"
  schedule = "*/15"
}
resource "proxmox_replication" "docker3-replication-2" {
  id = format("%d-1", module.vm["docker3"].vm_id)
  target = "pve02"
  type   = "local"
  schedule = "*/15"
}
resource "proxmox_replication" "caddy-replication-0" {
  id = format("%d-0", module.lxc["caddy"].vm_id)
  target = "pve01"
  type   = "local"
  schedule = "*/15"
}
resource "proxmox_replication" "caddy-replication-1" {
  id = format("%d-1", module.lxc["caddy"].vm_id)
  target = "pve02"
  type   = "local"
  schedule = "*/15"
}
resource "proxmox_replication" "jellyfin-replication-0" {
  id = format("%d-0", module.lxc["jellyfin"].vm_id)
  target = "pve02"
  type   = "local"
  schedule = "*/15"
}
resource "proxmox_replication" "jellyfin-replication-1" {
  id = format("%d-1", module.lxc["jellyfin"].vm_id)
  target = "pve03"
  type   = "local"
  schedule = "*/15"
}
resource "proxmox_replication" "forgejo-replication-1" {
  id = format("%d-0", module.lxc["forgejo"].vm_id)
  target = "pve01"
  type   = "local"
  schedule = "*/15"
}
resource "proxmox_replication" "forgejo-replication-2" {
  id = format("%d-1", module.lxc["forgejo"].vm_id)
  target = "pve02"
  type   = "local"
  schedule = "*/15"
}
resource "proxmox_replication" "postgres-replication-1" {
  id = format("%d-0", module.lxc["postgres"].vm_id)
  target = "pve01"
  type   = "local"
  schedule = "*/5"
}
resource "proxmox_replication" "postgres-replication-2" {
  id = format("%d-1", module.lxc["postgres"].vm_id)
  target = "pve03"
  type   = "local"
  schedule = "*/5"
}
resource "proxmox_replication" "netbird-replication-1" {
  id = format("%d-0", module.lxc["netbird-gateway"].vm_id)
  target = "pve02"
  type   = "local"
  schedule = "*/30"
}
resource "proxmox_replication" "netbird-replication-2" {
  id = format("%d-1", module.lxc["netbird-gateway"].vm_id)
  target = "pve03"
  type   = "local"
  schedule = "*/30"
}
resource "proxmox_replication" "pangolin-replication-1" {
  id = format("%d-0", module.lxc["pangolin-gateway"].vm_id)
  target = "pve02"
  type   = "local"
  schedule = "*/30"
}
resource "proxmox_replication" "pangolin-replication-2" {
  id = format("%d-1", module.lxc["pangolin-gateway"].vm_id)
  target = "pve03"
  type   = "local"
  schedule = "*/30"
}
resource "proxmox_replication" "hermes-replication-1" {
  id = format("%d-0", module.lxc["hermes"].vm_id)
  target = "pve01"
  type   = "local"
  schedule = "*/30"
}
resource "proxmox_replication" "hermes-replication-2" {
  id = format("%d-1", module.lxc["hermes"].vm_id)
  target = "pve02"
  type   = "local"
  schedule = "*/30"
}
