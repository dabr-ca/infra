locals {
  default_terraform_version = "1.5.5"

  csv = csvdecode(file("../../datasources/tfc/workspaces.csv"))
  workspaces = {
    for workspace in local.csv :
    workspace["name"] => {
      name                = trimspace(workspace["name"])
      auto_apply          = tobool(workspace["auto_apply"])
      global_remote_state = tobool(workspace["global_remote_state"])
      modules             = compact(split(":", trimspace(workspace["modules"])))
    }
  }
}
