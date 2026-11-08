terraform {
  required_version = ">= 1.12"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.116.0"
    }
    technitium = {
      source  = "darkhonor/technitium"
      version = "~> 1.2"
    }
    forgejo = {
      source  = "svalabs/forgejo"
      version = "~> 1.6.0"
    }
    infisical = {
      source  = "Infisical/infisical"
      version = "0.20.8" 
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
}
