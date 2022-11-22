resource "aws_ses_domain_identity" "main" {
  domain = data.aws_route53_zone.main.name
}

resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain
}

resource "aws_ses_domain_identity_verification" "main" {
  domain = aws_ses_domain_identity.main.domain
}

resource "aws_route53_record" "dkim" {
  count = 3

  zone_id = data.aws_route53_zone.main.id
  name    = "${element(aws_ses_domain_dkim.main.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = 600
  records = ["${element(aws_ses_domain_dkim.main.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_route53_record" "spf" {
  zone_id = data.aws_route53_zone.main.id
  name    = aws_ses_domain_identity.main.domain
  type    = "TXT"
  ttl     = 600
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_iam_user" "ses" {
  name = "${local.name}-ses-smtp"
}

resource "aws_iam_user_policy" "ses" {
  user   = aws_iam_user.ses.name
  policy = data.aws_iam_policy_document.ses.json
}

data "aws_iam_policy_document" "ses" {
  statement {
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}

resource "aws_iam_access_key" "ses" {
  user = aws_iam_user.ses.name
}

resource "aws_ssm_parameter" "ses_username" {
  name  = "/${local.name}/ses/username"
  type  = "String"
  value = aws_iam_access_key.ses.id
}

resource "aws_ssm_parameter" "ses_password" {
  name  = "/${local.name}/ses/password"
  type  = "SecureString"
  value = aws_iam_access_key.ses.ses_smtp_password_v4
}
