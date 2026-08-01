# Day 02 - Terraform Workflow Notes

## Terraform Workflow

1. Write Infrastructure as Code
   - Create `.tf` files describing resources, providers, variables, and outputs.
   - Terraform configuration is declarative: you define *what* you want, not *how* to build it.

2. Initialize the Working Directory
   - Run `terraform init` to download provider plugins and initialize the backend.
   - Initialization prepares Terraform to manage the target cloud or platform.

3. Review Changes with Plan
   - Run `terraform plan` to preview the actions Terraform will take.
   - The plan shows resources to create, update, or destroy before applying any changes.

4. Apply the Configuration
   - Run `terraform apply` to make the infrastructure match the desired configuration.
   - Terraform creates, updates, or deletes resources automatically based on the plan.

5. Maintain and Change Infrastructure
   - Update `.tf` files when requirements change.
   - Re-run `terraform plan` and `terraform apply` to reconcile the current state with the new configuration.

6. Cleanup with Destroy
   - Run `terraform destroy` to remove all managed resources.
   - This command is useful for tearing down temporary or test infrastructure.

## How Terraform Automates Infrastructure Creation

- Terraform reads the configuration files and converts them into a resource graph.
- It determines dependencies between resources so operations occur in the correct order.
- Terraform uses provider plugins to talk to cloud APIs and create infrastructure automatically.
- The apply phase executes the planned changes and provisions resources without manual intervention.

## Terraform State Management

- Terraform stores state in a `terraform.tfstate` file by default.
- State tracks the real-world resources that Terraform manages and maps them to the configuration.
- It is used to detect drift, plan changes, and know what already exists.

### State Maintenance

- Local state is stored on disk, but remote backends like S3, Azure Storage, or Terraform Cloud are recommended for team use.
- Remote state backends provide shared storage and state locking to avoid concurrent modifications.
- Terraform state should be treated as sensitive: it can contain resource IDs, secrets, and metadata.
- When state changes, Terraform updates the state file after successful `apply` so future plans are accurate.

## Best Practices

- Keep state remote for collaboration.
- Use `terraform init` whenever backend configuration changes.
- Never edit the state file manually unless you understand the consequences.
- Use `terraform plan` as a review step before `terraform apply`.
