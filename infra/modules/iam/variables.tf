variable "project_name" {
  description = "Project name used for IAM role naming and tagging"
  type        = string
}

variable "additional_task_policies" {
  description = "List of additional IAM policy ARNs to attach to the ECS task role"
  type        = list(string)
  default     = []
}

variable "cloudwatch_log_group_arn" {
  description = "CloudWatch log group ARN the tasks will write to"
  type        = string
  default     = ""
}

variable "ecr_repository_arns" {
  description = "List of ECR repository ARNs the task/execution roles should be able to pull from"
  type        = list(string)
  default     = []
}
