locals {
  internal_schryborg = {
    pve01 = {
      ip_address = "192.168.1.11"
    }
    pve02 = {
      ip_address = "192.168.1.12"
    }
    pve03 = {
      ip_address = "192.168.1.13"
    }
    kube = {
      ip_address = "192.168.50.80"
    }
    su-pi-visor = {
      ip_address = "192.168.1.9"
    }
    pi-nut = {
      ip_address = "192.168.1.10"
    }
    uzg-01 = {
      ip_address = "192.168.1.70"
    }
  }
  dns_hosts = {
    for name, cfg in merge(local.vms, local.lxc, local.internal_schryborg) :
    name => split("/", cfg.ip_address)[0]
    if cfg.ip_address != null && cfg.ip_address != "dhcp"
  }
  schryborg = {
    caddy = {
      type       = "A"
      ip_address = "192.168.50.5"
    }
  }
}

resource "technitium_zone" "schryborg" {
  name = "schryborg.de"
  type = "Primary"
}

resource "technitium_zone" "internal" {
  name = "internal.schryborg.de"
  type = "Primary"
}

resource "technitium_record" "internal_hosts" {
  for_each  = local.dns_hosts
  zone      = technitium_zone.internal.name
  name      = "${each.key}.${technitium_zone.internal.name}"
  type      = "A"
  value     = each.value
  ttl       = 3600
  overwrite = false
}

resource "technitium_record" "caddy" {
  zone      = "schryborg.de"
  name      = "caddy.schryborg.de"
  type      = "A"
  value     = "192.168.50.5"
  ttl       = 3600
  overwrite = false
}

resource "technitium_record" "wildcard-schryborg" {
  zone      = "schryborg.de"
  name      = "*.schryborg.de"
  type      = "CNAME"
  value     = "caddy.schryborg.de"
  overwrite = false
}

resource "technitium_record" "sputnik" {
  zone      = "schryborg.de"
  name      = "sputnik.schryborg.de"
  type      = "A"
  value     = "87.106.21.251"
  ttl       = 3600
  overwrite = false
}

resource "technitium_record" "pangolin" {
  zone      = "schryborg.de"
  name      = "pangolin.schryborg.de"
  type      = "CNAME"
  value     = "sputnik.schryborg.de"
  ttl       = 3600
  overwrite = false
}

resource "technitium_record" "netbird" {
  zone      = "schryborg.de"
  name      = "netbird.schryborg.de"
  type      = "CNAME"
  value     = "sputnik.schryborg.de"
  ttl       = 3600
  overwrite = false
}
resource "technitium_record" "k3s" {
  zone      = "schryborg.de"
  name      = "k3s.schryborg.de"
  type      = "A"
  value     = "192.168.50.80"
  ttl       = 3600
  overwrite = false
}
resource "technitium_record" "wildcard-k3s" {
  zone      = "schryborg.de"
  name      = "*.k3s.schryborg.de"
  type      = "A"
  value     = "192.168.50.200"
  overwrite = false
}
