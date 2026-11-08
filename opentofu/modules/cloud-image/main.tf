resource "proxmox_download_file" "this" {
  content_type = var.cimage_content_type
  datastore_id = var.cimage_datastore_id
  node_name    = var.cimage_node_name
  url          = var.cimage_url
  file_name    = var.cimage_file_name
  overwrite    = var.cimage_overwrite
}
