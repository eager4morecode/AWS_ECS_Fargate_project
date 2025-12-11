resource "aws_wafv2_web_acl" "this" {
  name        = "${var.project_name}-web-acl"
  description = "WAF ACL for the ECS Fargate ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-waf"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-common"
      sampled_requests_enabled   = true
    }
  }
}
 
resource "aws_wafv2_web_acl_association" "alb_assoc" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
