variable "project_name" {
  description = "Project / service name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ECS service networking"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where ECS tasks will run"
  type        = list(string)
}

variable "ecs_execution_role_arn" {
  description = "IAM role ARN used by ECS agent to pull images and write logs"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "IAM role ARN assumed by the application container"
  type        = string
}

variable "container_image" {
  description = "Full image URL (including tag) for the container"
  type        = string
}

variable "container_port" {
  description = "Container port exposed and registered with the target group"
  type        = number
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "target_group_arn" {
  description = "Target group ARN used by the ECS service"
  type        = string
}

variable "service_security_group_id" {
  description = "Security group ID attached to the ECS tasks' ENIs"
  type        = string
}

variable "assign_public_ip" {
  description = "Whether to assign public IPs to ECS tasks"
  type        = bool
  default     = false
}

variable "cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate task memory in MiB"
  type        = number
  default     = 512
}

variable "environment" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "APP_ENV"
      value = "prod"
    }
  ]
}

variable "log_group_name" {
  description = "Name of CloudWatch log group for ECS task logs"
  type        = string
  default     = ""
}
