data "infisical_secrets" "forgejo_users" {
  workspace_id = "456ca837-a7a3-44da-94c5-8e4a98d32756"
  env_slug     = "prod"
  folder_path  = "/forgejo"
}
# not working in infisical provider 0.19.39
# data "infisical_secrets" "technitium" {
#   workspace_id = "7de0c8a5-3ac3-4518-b1bd-c764dcc7379a"
#   env_slug     = "prod"
#   folder_path  = "/technitium"
# }
#
# data "infisical_secrets" "flux" {
#   workspace_id = "7de0c8a5-3ac3-4518-b1bd-c764dcc7379a"
#   env_slug     = "prod"
#   folder_path  = "/flux"
# }
