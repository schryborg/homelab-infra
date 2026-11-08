variable "container_name" {
  description = "Name of the LXC container. Also used as its hostname."
  type        = string
}

variable "node_name" {
  description = "Proxmox node to create the LXC container on."
  type        = string
}

variable "vm_id" {
  description = "Numeric container ID. Leave null to let Proxmox assign the next free ID."
  type        = number
  default     = null
}

variable "description" {
  description = "Free-text description shown in the Proxmox UI."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to the container (visible in the Proxmox UI). The tag 'opentofu' is always added."
  type        = list(string)
  default     = []
}

# --- OS template ---

variable "os_template_file_id" {
  description = "Proxmox OS template file ID, e.g. 'local:vztmpl/debian-12-standard_12_amd64.tar.zst'. Leave null when importing existing containers."
  type        = string
  default     = null
}

variable "os_type" {
  description = "OS type"
  type        = string
  default     = "debian"
}

variable "unprivileged" {
  description = "Whether the container should be unprivileged."
  type        = bool
  default     = true
}

variable "features" {
  description = "Container features (nesting, fuse, keyctl, mknod, allowed mount types)."
  type = object({
    nesting = optional(bool, false)
    fuse    = optional(bool, false)
    keyctl  = optional(bool, false)
    mknod   = optional(bool, false)
    mount   = optional(list(string), [])
  })
  default = {
    nesting = true
  }
}

variable "console" {
  description = "Console configuration for the container."
  type = object({
    enabled   = optional(bool, true)
    tty_count = optional(number, 2)
    type      = optional(string, "tty")
  })
  default = {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }
}

# --- Compute resources ---

variable "cpu_cores" {
  description = "Number of CPU cores."
  type        = number
  default     = 1
}

variable "cpu_architecture" {
  description = "CPU architecture, e.g. 'amd64'."
  type        = string
  default     = "amd64"
}

variable "memory_mb" {
  description = "Amount of dedicated RAM in MB."
  type        = number
  default     = 512
}

variable "swap_mb" {
  description = "Amount of swap in MB."
  type        = number
  default     = 512
}

# --- Disk ---

variable "disk_datastore" {
  description = "Datastore (storage) ID for the root disk, e.g. 'local-zfs'."
  type        = string
  default     = "local-zfs"
}

variable "disk_size_gb" {
  description = "Size of the root disk in GB."
  type        = number
  default     = 8
}

variable "devices" {
  description = "Devices to pass through to the container."
  type = list(object({
    path       = string
    gid        = optional(number)
    uid        = optional(number)
    mode       = optional(string)
    deny_write = optional(bool)
  }))
  default = []
}

variable "mount_points" {
  description = "Bind mount points."
  type = list(object({
    volume        = string
    path          = string
    read_only     = optional(bool, false)
    shared        = optional(bool, false)
    mount_options = optional(list(string), [])
  }))
  default = []
}

# --- Network ---

variable "network_bridge" {
  description = "Linux bridge to attach the primary NIC to, e.g. 'vmbr0'."
  type        = string
  default     = "vmbr0"
}

variable "network_name" {
  description = "Name of the container network interface."
  type        = string
  default     = "eth0"
}

variable "vlan_id" {
  description = "VLAN tag for the primary NIC. Leave null for no tagging."
  type        = number
  default     = 50
}

variable "network_firewall" {
  description = "Enable firewall on the primary network interface."
  type        = bool
  default     = false
}

variable "ip_address" {
  description = "IPv4 address in CIDR notation (e.g. '192.168.1.50/24') or 'dhcp'."
  type        = string
  default     = "dhcp"
}

variable "gateway" {
  description = "IPv4 gateway. Ignored when ip_address is 'dhcp'."
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "DNS servers to hand to the container via cloud-init."
  type        = list(string)
  # default     = []
  default = null
}

variable "dns_domain" {
  description = "DNS search domain for the container."
  type        = string
  default     = null
}

# --- Initial access ---

variable "ssh_public_keys" {
  description = "Public SSH keys authorized for the container's root user."
  type        = list(string)
  default     = []
}

variable "root_password" {
  description = "Password for the container's root user. Prefer ssh_keys over a password; leave null to disable password auth."
  type        = string
  default     = null
  sensitive   = true
}

# --- Lifecycle ---

variable "started" {
  description = "Whether the container should be running after apply."
  type        = bool
  default     = true
}

variable "start_on_boot" {
  description = "Whether the container starts automatically when the Proxmox host boots."
  type        = bool
  default     = true
}
