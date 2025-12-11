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

## DevSecOps & Security

This project includes a basic DevSecOps pipeline and cloud security posture:

- **CI/CD Security Gates**
  - SAST with **Bandit** for Python code
  - Python dependency scanning with **pip-audit**
  - **Terraform** IaC security scanning with **Checkov**
  - Container filesystem scanning with **Trivy**
  - (Optional) Secret scanning with **Gitleaks**

- **Cloud-Native Security**
  - ECR image scanning on push
  - ECS tasks running in private subnets behind an ALB
  - IAM roles following least privilege
  - AWS WAF** Web ACL in front of the ALB using AWS managed rules
  - GuardDuty** and **Security Hub** enabled for account-level threat detection

These checks run automatically on every push and pull request. The deployment job only runs if all security checks pass.

