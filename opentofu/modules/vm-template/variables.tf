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

variable "memory_mb" {
  description = "Amount of dedicated RAM in MB."
  type        = number
  default     = 2048
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
  default     = 10
}

variable "disk_interface" {
  description = "disk interface/slot for the primary disk."
  type        = string
  default     = "scsi0"
}

variable "disk_ssd" {
  description = "Enable SSD emulation for the primary disk."
  type        = bool
  default     = true
}

# --- Network ---

variable "network_bridge" {
  description = "Linux bridge to attach the primary NIC to, e.g. \"vmbr0\"."
  type        = string
  default     = "vmbr0"
}

variable "network_model" {
  description = "Emulated NIC model."
  type        = string
  default     = "virtio"
}

variable "vlan_id" {
  description = "VLAN tag for the primary NIC. Leave null for no tagging (access port)."
  type        = number
  default     = 50
}

# --- Cloud-init ---

variable "cloud_image_file_id" {
  description = "Cloud image file id"
  type        = string
  default     = null
}

variable "dns_domain" {
  description = "DNS search domain for the guest. Leave null to inherit from the template."
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "DNS servers to hand to the guest via cloud-init. Leave empty to inherit Proxmox host defaults."
  type        = list(string)
  default     = []
}

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

variable "user_data_file_id" {
  description = "Proxmox file ID of a cloud-init user-data snippet to apply during template creation."
  type        = string
  default     = null
}

variable "agent_enabled" {
  description = "Whether to enable the QEMU guest agent (template must have it installed)."
  type        = bool
  default     = true
}
