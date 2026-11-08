resource "forgejo_user" "luke" {
  login    = "luke"
  email    = data.infisical_secrets.forgejo_users.secrets["luke_email"].value
  password = data.infisical_secrets.forgejo_users.secrets["luke_password"].value
  admin    = true
  must_change_password = false
}

resource "forgejo_user" "renovate-bot" {
  login    = "renovate-bot"
  email    = data.infisical_secrets.forgejo_users.secrets["renovate-bot_email"].value
  password = data.infisical_secrets.forgejo_users.secrets["renovate-bot_password"].value
  must_change_password = false
}

resource "forgejo_user" "terraform" {
  login    = "terraform"
  email    = data.infisical_secrets.forgejo_users.secrets["terraform_email"].value
  password = data.infisical_secrets.forgejo_users.secrets["terraform_password"].value
  admin    = true
  must_change_password = false
}

resource "forgejo_repository" "archibald" {
  name  = "archibald"
  owner = forgejo_user.luke.login
}
resource "forgejo_repository" "cyborg_nvim" {
  name  = "cyborg.nvim"
  owner = forgejo_user.luke.login
}
resource "forgejo_repository" "colorschemes" {
  name  = "colorschemes"
  owner = forgejo_user.luke.login
}
resource "forgejo_repository" "dotfiles" {
  name  = "dotfiles"
  owner = forgejo_user.luke.login
}
resource "forgejo_repository" "flux" {
  name        = "flux"
  owner       = forgejo_user.luke.login
  description = "Flux repository"
  private     = false
  auto_init   = true # flux_bootstrap_git needs an already-initialised repository
}

resource "tls_private_key" "flux_private_key" {
  algorithm = "ED25519"
}

resource "forgejo_deploy_key" "flux_deploy_key" {
  title         = "flux"
  repository_id = forgejo_repository.flux.id
  key           = trimspace(tls_private_key.flux_private_key.public_key_openssh)
  read_only     = false
}
resource "forgejo_repository" "qemu-kvm-pcie-passthrough" {
  name  = "qemu-kvm-pcie-passthrough"
  owner = forgejo_user.luke.login
}
