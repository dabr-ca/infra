# This workspace uses tfe provider to manages all workspaces on Terraform Cloud,
# including itself.

data "tfe_organization" "dabr-ca" {
  name = "dabr-ca"
}

locals {
  # https://app.terraform.io/app/dabr-ca/settings/version-control
  gh_oauth_token_id = "ot-YGoaidJBNjpHQTj3"
}

resource "tfe_workspace" "workspaces" {
  for_each = local.workspaces

  name                = each.key
  organization        = data.tfe_organization.dabr-ca.name
  terraform_version   = local.default_terraform_version
  allow_destroy_plan  = false
  auto_apply          = each.value.auto_apply
  execution_mode      = "remote"
  global_remote_state = each.value.global_remote_state

  trigger_prefixes = flatten([
    "/datasources/${each.key}",
    [for m in each.value.modules : "/modules/${m}"],
  ])

  vcs_repo {
    identifier     = "dabr-ca/infra"
    oauth_token_id = local.gh_oauth_token_id
  }
  working_directory = "/workspaces/${each.key}"
}
