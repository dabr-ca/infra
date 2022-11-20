# iam.tf
moved {
  from = aws_iam_role.main
  to   = module.mastodon.aws_iam_role.main
}
moved {
  from = aws_iam_instance_profile.main
  to   = module.mastodon.aws_iam_instance_profile.main
}
moved {
  from = aws_iam_role_policy_attachment.s3
  to   = module.mastodon.aws_iam_role_policy_attachment.s3
}
moved {
  from = aws_iam_role_policy.main
  to   = module.mastodon.aws_iam_role_policy.main
}

# lb.tf
moved {
  from = aws_lb.main
  to   = module.mastodon.aws_lb.main
}
moved {
  from = aws_lb_listener.main_http
  to   = module.mastodon.aws_lb_listener.main_http
}
moved {
  from = aws_lb_listener.main_https
  to   = module.mastodon.aws_lb_listener.main_https
}
moved {
  from = aws_lb_target_group.main
  to   = module.mastodon.aws_lb_target_group.main
}
moved {
  from = aws_lb_target_group_attachment.main
  to   = module.mastodon.aws_lb_target_group_attachment.main
}
