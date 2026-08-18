# Terraform Fundamentals for Production Environments

## What is Terraform?
Terraform is an Infrastructure as Code (IaC) tool from HashiCorp used to define, provision, and manage cloud resources in a repeatable, version-controlled manner.

In a production setup, Terraform helps teams:
- automate infrastructure provisioning instead of manual console clicks
- keep environments consistent across dev, test, and prod
- review infrastructure changes through pull requests and code reviews
- reduce drift between desired and actual cloud state
- support safer and faster recovery from failures

## Why Terraform is important in production
Terraform is not just for simple resource creation. In real-world operations, it becomes the source of truth for infrastructure and is used to:
- standardize architecture across teams
- support blue/green or rolling deployments
- enable disaster recovery and reproducible environment recreation
- manage large, multi-account AWS environments
- track and audit infrastructure changes via Git history

## Terraform provider concept
A provider is a plugin that allows Terraform to communicate with a specific platform such as AWS, Azure, GCP, or Kubernetes.

For AWS, the provider translates Terraform configuration into API calls that AWS understands.

Official AWS provider documentation:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs

This is a critical part of production design because provider versions directly impact compatibility, feature availability, and bug fixes.

## Why version pinning matters
Using the latest version automatically may introduce breaking changes or behavior changes that are not compatible with your current Terraform configuration.

Production environments should always pin:
- Terraform version
- provider versions
- module versions when applicable

This reduces surprises during releases and makes upgrades intentional and controlled.

## Version constraint operators
Terraform allows version constraints to control compatibility.

Common operators:
- = exact version
- != exclude a specific version
- >, >=, <, <= comparison-based constraints
- ~> pessimistic operator for compatible updates

Examples:
- = 1.5.7 -> only version 1.5.7
- >= 1.5.0, < 2.0.0 -> version range
- ~> 1.0.4 -> allows 1.0.x, but not 1.1.x
- ~> 1.1 -> allows 1.x, but not 2.0

Example from this project:
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.3.0"
}
```

## Provider configuration example
```hcl
provider "aws" {
  region = "us-east-1"
}
```

This is the entry point for AWS API access. In production, you would usually also add:
- shared credentials or IAM roles
- assume-role patterns for cross-account access
- standard-region selection via variables
- environment-specific configuration per account
