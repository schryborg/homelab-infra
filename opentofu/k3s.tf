resource "flux_bootstrap_git" "this" {
  depends_on = [forgejo_deploy_key.flux_deploy_key]

  embedded_manifests = true
  path               = "clusters/homelab"
}
