variable "project_name" {
  description = "Short name for tagging and naming"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the ALB will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB"
  type        = list(string)
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
  default     = "/health"
}

variable "health_check_port" {
  description = "Port for ALB health checks"
  type        = string
  default     = "traffic-port"
}

variable "listener_port" {
  description = "Port on which ALB will listen"
  type        = number
  default     = 80
}

variable "target_port" {
  description = "Port on container / target that traffic is forwarded to"
  type        = number
  default     = 8080
}
