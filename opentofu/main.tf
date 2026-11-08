data "proxmox_version" "version" {}

data "proxmox_virtual_environment_nodes" "nodes" {}

locals {
  # All *.pub files under ssh-keys/, one key per line (blank lines ignored).
  ssh_public_keys = flatten([
    for f in fileset("${path.module}", "../ssh-keys/deploy/*.pub") :
    [for line in split("\n", file("${path.module}/${f}")) : trimspace(line) if trimspace(line) != ""]
  ])
}

