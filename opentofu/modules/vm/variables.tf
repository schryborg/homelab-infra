variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "node_name" {
  description = "Proxmox node to create the VM"
  type        = string
}

variable "vm_id" {
  description = "Numeric VM ID. Leave null to let Proxmox assign the next free ID."
  type        = number
  default     = null
}

variable "description" {
  description = "Free-text description shown in the Proxmox UI."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to the VM (visible in the Proxmox UI). The tag 'opentofu' is always added."
  type        = list(string)
  default     = []
}

variable "scsi_hardware" {
  description = "SCSI Hardware"
  type        = string
  default     = "virtio-scsi-single"
}

# --- Cloning ---

variable "template_vm_id" {
  description = "VM ID of the cloud-init-ready template to clone from. Leave null to create or import a VM without cloning."
  type        = number
  default     = null
}

variable "template_node_name" {
  description = "Node the template lives on, if different from node_name (needed for cross-node clone)."
  type        = string
  default     = null
}

variable "full_clone" {
  description = "Whether to do a full clone (true) instead of a linked clone (false)."
  type        = bool
  default     = true
}

# --- Compute resources ---

variable "bios" {
  description = "BIOS"
  type        = string
  default     = "ovmf"

  validation {
    condition     = contains(["seabios", "ovmf"], var.bios)
    error_message = "BIOS must be 'seabios' or 'ovmf'."
  }
}

variable "machine" {
  description = "Machine"
  type        = string
  default     = "q35"

  validation {
    condition     = contains(["pc", "q35"], var.machine)
    error_message = "Machine must be 'pc' or 'q35'."
  }
}

variable "operating_system" {
  description = "Guest operating system type (e.g. 'l26' for Linux 2.6 - 6.x)."
  type        = string
  default     = "l26"
}

variable "cpu_cores" {
  description = "Number of CPU cores."
  type        = number
  default     = 2
}

variable "cpu_sockets" {
  description = "Number of CPU sockets."
  type        = number
  default     = 1
}

variable "cpu_type" {
  description = "CPU type presented to the guest (e.g. \"host\", \"x86-64-v2-AES\")."
  type        = string
  default     = "host"
}

variable "cpu_flags" {
  description = "CPU flags"
  type        = list(string)
  default     = []
}

variable "memory_mb" {
  description = "Amount of dedicated RAM in MB."
  type        = number
  default     = 2048
}

variable "balloon_mb" {
  description = "Minimum memory (MB) for ballooning. Set equal to memory_mb to disable ballooning."
  type        = number
  default     = 0
}

# --- Disk ---

variable "disk_datastore" {
  description = "Datastore (storage) ID for the primary disk, e.g. \"local-lvm\"."
  type        = string
  default     = "local-zfs"
}

variable "disk_size_gb" {
  description = "Size of the primary disk in GB. Must be >= the template's disk size. Leave null to inherit from the template."
  type        = number
  default     = null
}

variable "disk_interface" {
  description = "disk interface/slot for the primary disk."
  type        = string
  default     = "scsi0"
}

variable "disk_ssd" {
  description = "SSD flag"
  type        = bool
  default     = true
}

variable "extra_disks" {
  description = "Additional disks to attach."
  type = list(object({
    datastore_id = optional(string, "local-zfs")
    interface    = optional(string, null)
    size         = number
  }))
  default = []

  validation {
    condition     = alltrue([for d in var.extra_disks : d.interface != null])
    error_message = "All extra_disks must have an explicit interface set (e.g. scsi1, scsi2)."
  }
}

# --- EFI Disk ---
variable "efi_disk_type" {
  description = "efi disk type, defaults to 2m"
  type        = string
  default     = "4m"
}

variable "efi_disk_pre_enrolled_keys" {
  description = "efi disk preenrolled keys"
  type        = bool
  default     = true
}

# --- Network ---

variable "network_devices" {
  description = "network devices"
  type = list(object({
    network_bridge  = string
    network_model   = string
    vlan_id         = optional(number, null)
    firewall        = bool
    queues          = optional(number)
  }))
  default = []

  validation {
    condition     = alltrue([for d in var.network_devices : d.network_bridge != null])
    error_message = "All network_devices must have an explicit network_bridge set (e.g. vmbr0, vmbr1)."
  }
}
# variable "network_bridge" {
#   description = "Linux bridge to attach the primary NIC to, e.g. \"vmbr0\"."
#   type        = list(string)
#   default     = ["vmbr0"]
# }
#
# variable "network_model" {
#   description = "Emulated NIC model."
#   type        = string
#   default     = "virtio"
# }
#
# variable "network_firewall" {
#   description = "Firewall enabled"
#   type        = bool
#   default     = false
# }
#
# variable "vlan_id" {
#   description = "VLAN tag for the primary NIC. Leave null for no tagging (access port)."
#   type        = number
#   default     = 50
# }

variable "ip_address" {
  description = "IPv4 address in CIDR notation (e.g. \"192.168.1.50/24\"), or \"dhcp\"."
  type        = string
  default     = "dhcp"
}

variable "gateway" {
  description = "IPv4 gateway. Ignored when ip_address is \"dhcp\"."
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "DNS servers to hand to the guest via cloud-init. Leave empty to inherit Proxmox host defaults."
  type        = list(string)
  default     = []
}

variable "dns_domain" {
  description = "DNS search domain for the guest. Leave null to inherit from the template."
  type        = string
  default     = null
}

# --- Cloud-init ---

variable "username" {
  description = "Username to create via cloud-init."
  type        = string
  default     = "deploy"
}

variable "ssh_public_keys" {
  description = "Public SSH keys authorized for the cloud-init user."
  type        = list(string)
  default     = []
}

variable "cloud_init_enabled" {
  description = "Whether to manage cloud-init snippets and the initialization block. Set false for imported VMs that already have cloud-init configured."
  type        = bool
  default     = true
}

# --- Lifecycle ---

variable "started" {
  description = "Whether the VM should be running after apply."
  type        = bool
  default     = true
}

variable "start_on_boot" {
  description = "Whether the VM starts automatically when the Proxmox host boots."
  type        = bool
  default     = true
}

variable "agent_enabled" {
  description = "Whether to enable the QEMU guest agent (template must have it installed)."
  type        = bool
  default     = true
}
