resource "aws_guardduty_detector" "this" {
  enable = true
}

resource "aws_securityhub_account" "this" {
  enable_default_standards = true
}
