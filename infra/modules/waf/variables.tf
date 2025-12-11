variable "project_name" {
  type        = string
  description = "Project name for tagging"
}

variable "alb_arn" {
  type        = string
  description = "ARN of the ALB to associate with the Web ACL"
}
