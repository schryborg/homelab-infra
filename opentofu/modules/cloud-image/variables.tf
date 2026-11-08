variable "cimage_content_type" {
  description = "Content type for the downloaded cloud image (e.g. 'import')."
  type        = string
  default     = "import"
}

variable "cimage_datastore_id" {
  description = "Datastore ID where the cloud image is downloaded."
  type        = string
  default     = "local"
}

variable "cimage_node_name" {
  description = "Proxmox node used to download the cloud image."
  type        = string
  default     = "pve01"
}

variable "cimage_url" {
  description = "URL of the cloud image to download."
  type        = string
  default     = null
}
variable "cimage_file_name" {
  description = "File name for the downloaded cloud image."
  type        = string
  default     = null
}

variable "cimage_overwrite" {
  description = "overwrite the file"
  type        = bool
  default     = false
}
