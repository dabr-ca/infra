resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  alarm_name          = "StatusCheckFailed_${module.pleroma.instance.id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = module.pleroma.instance.id
  }

  alarm_actions = [
    "arn:aws:swf:${var.region}:${data.aws_caller_identity.current.account_id}:action/actions/AWS_EC2.InstanceId.Reboot/1.0",
    data.aws_sns_topic.default_cloudwatch.arn,
  ]

  actions_enabled = true
}
