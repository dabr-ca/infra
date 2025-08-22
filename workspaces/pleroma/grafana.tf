# Integration with Grafana Cloud

resource "random_uuid" "prometheus_token" {}

resource "aws_ssm_parameter" "prometheus_token" {
  name  = "/${local.name}/grafana/prometheus_token"
  type  = "SecureString"
  value = random_uuid.prometheus_token.result
}
