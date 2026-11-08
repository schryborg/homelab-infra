provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure
  ssh {
    agent       = false
    username    = var.proxmox_ssh_username
    private_key = file(pathexpand("~/.ssh/id_ed25519_terraform"))
  }
}

provider "technitium" {
  server_url = var.technitium_server_url
  api_token  = var.technitium_api_token

  stig_compliance {
    enabled = false
  }
}

provider "forgejo" {
  host      = "https://${var.forgejo_host}"
  api_token = var.forgejo_token
}

provider "infisical" {
  host = var.infisical_host
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

provider "flux" {
  kubernetes = {
    config_path = var.kubeconfig_path
  }
  git = {
    url = var.flux_git_url
    ssh = {
      username    = "git"
      private_key = trimspace(tls_private_key.flux_private_key.private_key_openssh)
    }
  }
}
