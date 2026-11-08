variable "proxmox_endpoint" {
  description = "Proxmox API endpoint, e.g. https://pve01:8006"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token in the form USER@REALM!TOKENID=UUID"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Disable TLS verification for the Proxmox API endpoint"
  type        = bool
  default     = false
}

variable "proxmox_ssh_username" {
  description = "SSH User"
  type        = string
  default     = "root"
}

variable "technitium_server_url" {
  description = "Technitium DNS Server API base URL"
  type        = string
}

variable "technitium_api_token" {
  description = "Technitium API token"
  type        = string
  sensitive   = true
}

variable "forgejo_host" {
  description = "Forgejo hostname"
  type        = string
  default     = ""
}

variable "forgejo_port" {
  description = "Forgejo port"
  type        = number
  default     = 3000
}

variable "forgejo_token" {
  description = "Forgejo API token"
  sensitive   = true
  type        = string
  default     = ""
}

variable "forgejo_org" {
  description = "Forgejo organization"
  type        = string
  default     = ""
}

variable "kubeconfig_path" {
  description = "Kubeconfig path"
  type        = string
  default     = "~/.kube/config"
}

variable "infisical_host" {
  description = "Infisical API host"
  type        = string
  default     = "https://infisical.schryborg.de"
}

variable "flux_git_url" {
  description = "Flux git url"
  type        = string
  default     = ""
}
