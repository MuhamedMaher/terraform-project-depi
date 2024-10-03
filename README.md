# Building Infrastructure with Terraform and Configuring Docker with Ansible

## Objective

This project aims to build and manage infrastructure across two availability zones (AZs) using Terraform and configure Docker on private machines using Ansible. The project leverages GitOps practices with a preferred CI/CD tool for automation.

## Tools Required

- **Terraform**: For building the infrastructure.
- **Ansible**: For configuration management and automation.
- **Docker**: To be installed on private machines and used for running containers.
- **GitOps**: For managing configurations and CI/CD processes.
- **CI/CD Tools**: Choose one (Jenkins, GitHub Actions, or GitLab Pipelines).

## Task Breakdown

### Terraform Infrastructure Setup

1. **Create VPC and Configure Network Needs**:
   - Define a VPC with the required CIDR block.
   - For each AZ, create two subnets: one public and one private.

2. **Set Up Auto Scaling Group (ASG)**:
   - Create an ASG with two instances.
   - Place the Load Balancer (LB) in the public subnets.
   - Deploy the instances in the private subnets.

3. **Ensure Private IPs are Passed to an Inventory File**:
   - Extract the private IPs of the instances for later use in Ansible.

### Bastion Host Configuration

- Set up a Bastion Host in the public subnet to manage access to the private instances.
- After creating the infrastructure, copy the necessary Ansible role and configuration files to the Bastion Host.

### Ansible Configuration

1. **Docker Installation**:
   - Use Ansible to install Docker on the private instances.
   - Create a custom Ansible role for Docker installation.

2. **Nginx Container Setup**:
   - Run an Nginx container on each private instance using Docker.

### GitOps Implementation

- Manage the entire configuration (Terraform and Ansible) using a Git repository.
- Implement CI/CD pipelines using your chosen tool (Jenkins, GitHub Actions, or GitLab Pipelines) to automate the deployment and configuration process.

## Hints

- You will execute the Ansible playbook on the Bastion Host.
- Ensure that all configurations and scripts are stored and managed in a Git repository.
- Use the inventory file created by Terraform to manage the target hosts for Ansible.

## Getting Started

### Prerequisites

- Ensure you have the required tools installed (Terraform, Ansible, Docker, and your chosen CI/CD tool).
- Access to an AWS account with appropriate permissions.

### Setup Instructions

1. Clone the repository to your local machine.
2. Navigate to the Terraform directory and initialize the configuration.
3. Run the Terraform scripts to set up the infrastructure.
4. Execute the Ansible playbook from the Bastion Host to configure Docker and deploy the Nginx container.

## Contributing

Contributions are welcome! Feel free to submit a pull request or open an issue for any improvements or bug fixes.




