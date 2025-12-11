variable "project_name" {
  description = "Name of the project / repository"
  type        = string
}

variable "image_scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting for the ECR repository"
  type        = string
  default     = "MUTABLE"
}
