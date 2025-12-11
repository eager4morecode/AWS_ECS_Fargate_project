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

### Security Architecture Summary

This project follows a Defense-in-Depth strategy combining application, container, infrastructure, and pipeline security:

**1. CI/CD DevSecOps Pipeline**
- GitHub Actions performs SAST (Bandit), dependency scanning (pip-audit), IaC scanning (Checkov), container scanning (Trivy), and secret scanning (Gitleaks).
- Only after all security checks pass, Terraform deploys infrastructure and updates ECS services.
- AWS IAM OIDC role removes the need for long-lived credentials.

**2. AWS WAF (Optional)**
- Protects ALB from common vulnerabilities (OWASP Top 10, bot mitigation).
- Blocks malicious requests before reaching the microservice.

**3. ALB → ECS Fargate**
- Application Load Balancer routes allowed traffic to ECS tasks.
- ALB uses strict security groups and health checks.
- ECS tasks run in isolated **private subnets** without public IPs.

**4. VPC Security**
- Public subnets: ALB only.
- Private subnets: ECS tasks, NAT-only egress.
- No direct inbound traffic to containers.

**5. Container + Image Security**
- ECR scan-on-push enabled.
- Trivy scans Dockerfile and final image.
- Immutable SHA tags used for deployment.

**6. IAM Governance**
- ECS Task Role follows least privilege.
- ECS Execution Role limited to ECR pulls + logging.
- CI/CD IAM permissions locked to Terraform state + ECS updates only.

**7. Monitoring + Threat Detection**
- CloudWatch logs/metrics for tasks and ALB.
- Optional GuardDuty + Security Hub for workload and account-level threat detection.

This layered approach creates a secure, automated, and compliant cloud microservice environment that aligns with modern DevSecOps practices.

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



