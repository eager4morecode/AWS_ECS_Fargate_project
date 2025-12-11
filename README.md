# AWS_ECS_Fargate_project
# Cloud-Native Microservice on AWS ECS Fargate

This project deploys a containerized Python microservice to **AWS ECS Fargate** using **Terraform** and **GitHub Actions**.

## Architecture

- AWS VPC (public + private subnets, NAT Gateway)
- ECS Fargate cluster + service
- Application Load Balancer (ALB) with health checks
- ECR for container images
- IAM roles with least privilege
- CloudWatch log groups and basic alarms
- CI/CD using GitHub Actions (Docker build + Terraform deploy)

## Tech Stack

- **Cloud:** AWS (ECS Fargate, ALB, ECR, VPC, IAM, CloudWatch)
- **IaC:** Terraform
- **Language:** Python (Flask)
- **Containers:** Docker
- **CI/CD:** GitHub Actions

## Endpoints

- `GET /` – simple greeting
- `GET /info` – service metadata
- `GET /health` – ALB health check

## How to Run Locally

```bash
cd app
pip install -r src/requirements.txt
python src/app.py
# visit http://localhost:8080
