# Terraform AWS EC2 Deployment

This project uses **Terraform** to provision an Ubuntu EC2 instance on AWS and automate infrastructure deployment through a **GitLab CI/CD pipeline**.

## Technologies Used

- Terraform
- AWS CLI
- GitLab CI/CD

## CI/CD Pipeline

The GitLab CI/CD pipeline automates the Terraform workflow through the following stages:

1. **Build** – Initialize Terraform and download the required providers. `terraform init`
2. **Test** – Validate the Terraform configuration. `terraform validate`
3. **Publish** – Generate a Terraform execution plan. `terraform plan`
4. **Deploy** – Apply the Terraform configuration to create AWS resources. `terraform apply -auto-approve`
5. **Post** – Manually destroy the created infrastructure when required. `terraform destroy -auto-approve`

The pipeline uses Terraform artifacts between jobs and executes Terraform commands using a Docker-based GitLab Runner.
