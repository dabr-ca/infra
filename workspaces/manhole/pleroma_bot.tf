resource "aws_ssm_parameter" "pleroma_bot_token" {
  name  = "/${local.name}/pleroma_bot_token"
  type  = "SecureString"
  value = "." # populate this value manually

  lifecycle {
    ignore_changes = [value]
  }
}
