# Terraform Workspaces

## 1. What is a Terraform Workspace?

A Terraform workspace is a named instance of a Terraform state. It allows you to manage multiple distinct state environments from the same configuration files.

Each workspace keeps its own separate state data, so the same `.tf` code can be applied to different environments or isolated deployments without changing the configuration.

### Key points
- One configuration can have many workspaces.
- Each workspace has its own state file.
- The default workspace is named `default`.
- Workspaces are useful for multiple environments like development, staging, and production.

## 2. The Problem Before Terraform Workspaces

Before workspaces, teams often created separate copies of the same Terraform code for each environment. This caused several issues:

- Duplicate configuration files.
- Harder to maintain and update.
- State files could get mixed up if the same backend was reused incorrectly.
- Adding a new environment required manual duplication.

With separate code copies, it was easy to introduce drift between environments and make mistakes when updating shared logic.

## 3. How Terraform Workspaces Work

Terraform workspaces map a workspace name to a specific state file. When you switch workspaces, Terraform reads and updates the state for that workspace.

Basic workflow:
1. Create or select a workspace.
2. Initialize Terraform with the backend.
3. Run `terraform plan` and `terraform apply`.
4. Terraform updates the state only for the selected workspace.

### Example commands

```bash
terraform workspace list
terraform workspace show
terraform workspace new dev
terraform workspace select staging
terraform workspace delete old-workspace
```

### Workspace-specific state handling

- Local backend: each workspace uses a separate local state file under `.terraform/`.
- Remote backend: the backend provider stores state per workspace, usually as separate objects or paths.

## 4. When to Use Workspaces

Workspaces are a good fit when you need multiple isolated instances of the same infrastructure configuration.

Common use cases:
- Multiple environments: `dev`, `qa`, `prod`
- Separate customer deployments using the same codebase
- Testing changes in a sandbox workspace without affecting production states

## 5. Workspace Examples

### Example: shared configuration for dev and prod

```bash
terraform workspace new dev
terraform apply -var="environment=dev"

terraform workspace new prod
terraform workspace select prod
terraform apply -var="environment=prod"
```

In this setup, the configuration stays the same, while each workspace maintains its own state.

### Example: Using workspace name in configuration

```hcl
locals {
  env = terraform.workspace
}

resource "aws_s3_bucket" "example" {
  bucket = "my-bucket-${local.env}"
}
```

This allows resource names or settings to change automatically based on the current workspace.

## 6. Advanced Workspace Topics

### Using `terraform.workspace`

The `terraform.workspace` built-in value returns the active workspace name. It can be used to adjust configuration dynamically.

### Conditional values by workspace

```hcl
locals {
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.micro"
}
```

This pattern enables different settings for prod versus non-prod workspaces while keeping one configuration.

### Workspace naming strategies

- `dev`, `qa`, `prod` for environments
- `customer-a`, `customer-b` for per-customer deployments
- feature-specific names for temporary testing workspaces

### Limitations and gotchas

- Workspaces are not a full replacement for separate Terraform configurations in all cases.
- Workspaces are best for infrastructure that can be safely created in multiple copies.
- Some resources should not be duplicated across workspaces if they share external names or unique identifiers.
- Workspaces do not isolate variable definitions. Variables still come from the same configuration and var files unless you pass separate ones.
- Do not use workspaces as a substitute for prod vs dev if the resources cannot be cloned safely.

### Best practices

- Keep workspace names short and meaningful.
- Use `terraform.workspace` only for small differences.
- Prefer separate configurations for extremely different environments.
- Use backend configuration that cleanly separates workspace states.
- Avoid storing sensitive data directly in workspace names or state metadata.

## 7. Helpful Terraform Workspace Tips

- Use `terraform workspace delete` carefully. It removes the workspace state, not the infrastructure.
- Always `terraform workspace select <name>` before planning or applying.
- Confirm the current workspace with `terraform workspace show`.
- Use `terraform plan -out=planfile` and `terraform apply planfile` to reduce risk.
- Keep environment-specific values in variables or separate `*.tfvars` files.

## 8. Summary

Terraform workspaces let you manage multiple state instances from a single configuration. They solve the issue of duplicated code and state confusion for repeated deployments.

Use workspaces for environment isolation and repeated deployments, but remember their limits. For advanced cases, combine workspace-aware configuration with thoughtful backend and variable management.
