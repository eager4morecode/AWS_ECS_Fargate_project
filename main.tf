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
