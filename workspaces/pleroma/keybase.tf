# Set up Keybase verification.

resource "aws_lb_listener_rule" "keybase" {
  listener_arn = data.aws_lb_listener.main_https.arn

  condition {
    host_header {
      values = [local.domain]
    }
  }
  condition {
    path_pattern {
      values = ["/keybase.txt"]
    }
  }

  action {
    type = "redirect"
    redirect {
      host        = "files.${local.domain}"
      status_code = "HTTP_302"
    }
  }
}

# ALB does not allow fixed-response body to be > 1024 bytes.
resource "aws_s3_object" "keybase" {
  bucket       = module.pleroma.bucket_main.bucket
  key          = "keybase.txt"
  content      = file("./files/keybase.txt")
  content_type = "text/plain"
}
