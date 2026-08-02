# Terraform Project Folder Structure (Industry Style)

This note is meant to help beginners understand how a Terraform project is usually organized in real-world and large-scale environments.

## Why folder structure matters

In small demos, everything can be kept in one file. But in large projects, teams need a clean and organized structure so that:

- code is easier to maintain
- multiple people can work together
- modules can be reused
- environments like dev, test, and prod remain separate
- infrastructure changes are safer and more predictable

## Common folder structure for a large Terraform project

A typical Terraform project may look like this:

```text
project-name/
├── modules/
│   └── aws_instance/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── shared/
│   ├── network/
│   └── security-group/
├── scripts/
├── variables/
├── outputs/
├── provider.tf
├── main.tf
├── terraform.tfvars
└── README.md
```

## Simple explanation of each folder

### 1. modules/
This folder contains reusable Terraform code.

Example:
- one module for EC2 instances
- one module for VPC
- one module for security groups

Why it is useful:
- avoid repeating code
- make infrastructure consistent
- easily reuse the same setup in many places

### 2. environments/
This folder keeps environment-specific configurations separate.

Example:
- dev for development
- staging for testing
- prod for production

Why it is useful:
- each environment can have its own values
- reduces risk of accidental changes in production

### 3. shared/
This folder can hold common resources used across multiple environments.

Example:
- shared networking
- common security groups
- common IAM roles

### 4. variables/
This folder or file is used to store input values such as:
- instance type
- region
- CIDR blocks
- tags

This keeps the main code cleaner and easier to understand.

### 5. outputs/
Outputs help return important values after Terraform applies the configuration.

Example outputs:
- instance public IP
- load balancer DNS name
- subnet IDs

### 6. provider.tf and main.tf
- provider.tf defines the cloud provider and authentication settings
- main.tf contains the main resource blocks and configuration

### 7. terraform.tfvars
This file stores actual values for variables.

Example:
- region = "us-east-1"
- instance_type = "t2.micro"

### 8. README.md
The README explains:
- what the project does
- how to initialize Terraform
- how to plan and apply changes
- how the folders are organized

## Important industry points for beginners

- Keep Terraform code modular.
- Do not put all resources in one giant file.
- Use separate folders for different environments.
- Use variables and tfvars instead of hardcoding everything.
- Reuse modules for common infrastructure pieces.
- Keep production-safe practices in mind.
- Always review the plan before applying changes.

## Beginner takeaway

In industry projects, Terraform is not just written as a small script. It is organized like a software project with:

- reusable modules
- environment-based folders
- clear configuration files
- strong separation of concerns

This makes the infrastructure easier to scale, secure, and manage.
