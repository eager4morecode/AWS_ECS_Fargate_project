/*
================================================================================
 Security Considerations (DevSecOps Overview)
================================================================================

This infrastructure is designed with a DevSecOps-first approach, ensuring that 
security controls are applied at every stage of the software delivery lifecycle.

1. Network Security
   - ECS tasks run in private subnets with no direct internet exposure.
   - Inbound traffic flows only through an ALB with restricted security groups.
   - NAT Gateway enables outbound access while maintaining task isolation.
   - VPC subnets and route tables restrict lateral movement.

2. Identity & Access Management (IAM)
   - ECS Task Role follows the principle of least privilege—only required 
     permissions are granted (e.g., CloudWatch logs, ECR read).
   - ECS Execution Role limited to ECR pulls and log writing.
   - Terraform Cloud/Actions deployment uses OIDC with a narrowly scoped role.
   - No long-lived CI/CD credentials are used.

3. Container Security
   - ECR repository is configured with `scan_on_push` to detect vulnerabilities.
   - CI/CD pipeline performs container scanning with Trivy before deployment.
   - Images are tagged with immutable SHAs to prevent supply chain tampering.

4. Infrastructure as Code (IaC) Security
   - CI/CD runs Checkov to enforce Terraform security policies (e.g., encryption,
     logging, IAM best practices, public exposure checks).
   - S3 backend for state should have versioning + encryption (KMS recommended).

5. Application Security (Static Code & Dependency Analysis)
   - Bandit runs SAST checks on Python application code.
   - pip-audit evaluates dependency vulnerabilities before builds proceed.

6. Runtime Protection (Optional Enhancements)
   - AWS WAF can be enabled to protect ALB from common web exploits (OWASP).
   - GuardDuty and Security Hub can be activated to monitor for threats, 
     misconfigurations, or anomalous behavior across the environment.

These controls together create a defense-in-depth posture that supports secure,
scalable, and automated deployment of microservices on AWS.
================================================================================
*/

module "network" {
  source               = "./modules/network"
  project_name         = var.project_name
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  ecr_repository_arns = [
    module.ecr.repository_arn
  ]
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}

module "ecs" {
  source                 = "./modules/ecs"
  project_name           = var.project_name
  aws_region             = var.aws_region
  vpc_id                 = module.network.vpc_id
  private_subnet_ids     = module.network.private_subnet_ids
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecs_task_role_arn      = module.iam.ecs_task_role_arn
  container_image        = "${module.ecr.repository_url}:${var.image_tag}"
  container_port         = 8080
  target_group_arn       = module.alb.target_group_arn
  desired_count          = 2
  service_security_group_id = aws_security_group.ecs_service.id
  log_group_name         = "/ecs/${var.project_name}"
}
module "waf" {
  source       = "./modules/waf"
  project_name = var.project_name
  alb_arn      = module.alb.alb_arn
}
