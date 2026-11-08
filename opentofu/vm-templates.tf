module "debian_cloud_image_pve01" {
  source = "./modules/cloud-image/"
  cimage_url       = "https://cloud.debian.org/images/cloud/trixie/20260803-2559/debian-13-generic-amd64-20260803-2559.qcow2"
  cimage_file_name = "debian-13-generic-amd64-20260803-2559.qcow2"
  cimage_node_name = "pve01"
}
module "debian_cloud_image_pve02" {
  source = "./modules/cloud-image/"
  cimage_url       = "https://cloud.debian.org/images/cloud/trixie/20260803-2559/debian-13-generic-amd64-20260803-2559.qcow2"
  cimage_file_name = "debian-13-generic-amd64-20260803-2559.qcow2"
  cimage_node_name = "pve02"
}
module "debian_cloud_image_pve03" {
  source = "./modules/cloud-image/"
  cimage_url       = "https://cloud.debian.org/images/cloud/trixie/20260803-2559/debian-13-generic-amd64-20260803-2559.qcow2"
  cimage_file_name = "debian-13-generic-amd64-20260803-2559.qcow2"
  cimage_node_name = "pve03"
}
module "debian_template_pve01" {
  source              = "./modules/vm-template/"
  vm_id               = 9001
  vm_name             = "debian-cloud-image-pve01"
  node_name           = "pve01"
  cloud_image_file_id = module.debian_cloud_image_pve01.id
  username            = "deploy"
  ssh_public_keys     = local.ssh_public_keys
  dns_domain          = "internal.schryborg.de"
}
module "debian_template_pve02" {
  source              = "./modules/vm-template/"
  vm_id               = 9002
  vm_name             = "debian-cloud-image-pve02"
  node_name           = "pve02"
  cloud_image_file_id = module.debian_cloud_image_pve02.id
  username            = "deploy"
  ssh_public_keys     = local.ssh_public_keys
  dns_domain          = "internal.schryborg.de"
}
module "debian_template_pve03" {
  source              = "./modules/vm-template/"
  vm_id               = 9003
  vm_name             = "debian-cloud-image-pve03"
  node_name           = "pve03"
  cloud_image_file_id = module.debian_cloud_image_pve03.id
  username            = "deploy"
  ssh_public_keys     = local.ssh_public_keys
  dns_domain          = "internal.schryborg.de"
}
