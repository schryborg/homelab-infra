output "id" {
  description = "File ID"
  value       = proxmox_download_file.this.id
}
output "file_name" {
  description = "File name"
  value       = proxmox_download_file.this.file_name
}
output "datastore_id" {
  description = "Datastore ID"
  value       = proxmox_download_file.this.datastore_id
}
