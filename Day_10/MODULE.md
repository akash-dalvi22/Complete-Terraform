# Terraform Modules

## What is a Terraform Module?

A Terraform module is a collection of Terraform configuration files (`.tf`) that are grouped together to perform a specific task. Modules allow you to write reusable, organized, and maintainable infrastructure code.

Every Terraform configuration contains at least one module called the **root module**. Any module that is called by the root module is known as a **child module**.

---

## Why Use Terraform Modules?

Terraform modules provide several benefits:

* **Reusability** – Write infrastructure code once and use it across multiple projects.
* **Consistency** – Enforce the same standards and configurations across environments.
* **Maintainability** – Update infrastructure logic in one place instead of multiple files.
* **Scalability** – Easily manage complex infrastructure by breaking it into smaller components.
* **Collaboration** – Teams can develop and maintain modules independently.

---

## Typical Module Structure

```text
terraform-module/
├── main.tf          # Main resource definitions
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── versions.tf      # Terraform and provider requirements
├── providers.tf     # Provider configuration (optional)
├── README.md        # Module documentation
├── MODULE.md        # Terraform module guide
├── examples/
│   └── basic/
│       ├── main.tf
│       └── terraform.tfvars
└── .gitignore
```

---

## Module Components

### main.tf

Contains the primary resource definitions for the module.

### variables.tf

Defines input variables that make the module configurable.

Example:

```hcl
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}
```

---

### outputs.tf

Returns useful information after the resources are created.

Example:

```hcl
output "resource_group_id" {
  value = azurerm_resource_group.example.id
}
```

---

### versions.tf

Defines the required Terraform and provider versions.

Example:

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
```

---

## How to Use a Module

Reference the module from another Terraform configuration using the `module` block.

Example:

```hcl
module "resource_group" {
  source = "github.com/<organization>/<repository>"

  resource_group_name = "rg-demo"
  location            = "East US"
}
```

For local development:

```hcl
module "resource_group" {
  source = "../terraform-module"

  resource_group_name = "rg-demo"
  location            = "East US"
}
```

---

## Module Inputs

Input variables allow users to customize the module without modifying its internal code.

Example:

```hcl
variable "location" {
  type        = string
  description = "Deployment location"
}
```

Usage:

```hcl
location = "East US"
```

---

## Module Outputs

Outputs expose important resource information for use by other modules or the root configuration.

Example:

```hcl
output "storage_account_name" {
  value = azurerm_storage_account.example.name
}
```

---

## Module Versioning

When publishing modules, use Git tags to version releases.

Example:

```hcl
module "storage" {
  source = "git::https://github.com/example/terraform-storage.git?ref=v1.0.0"
}
```

Using version tags ensures consistent and predictable deployments.

---

## Terraform Module Best Practices

* Keep each module focused on a single responsibility.
* Use descriptive variable and output names.
* Provide meaningful descriptions for variables and outputs.
* Avoid hard-coded values whenever possible.
* Use input validation where appropriate.
* Keep modules provider-agnostic when possible.
* Include example usage in the `examples/` directory.
* Document all inputs, outputs, and requirements.
* Follow semantic versioning (`v1.0.0`, `v1.1.0`, etc.).
* Test modules before publishing.

---

## Common Terraform Commands

Initialize the working directory:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Format Terraform files:

```bash
terraform fmt
```

Generate an execution plan:

```bash
terraform plan
```

Apply the infrastructure:

```bash
terraform apply
```

Destroy the infrastructure:

```bash
terraform destroy
```

---

## Module Development Workflow

1. Develop the module.
2. Run `terraform fmt`.
3. Run `terraform validate`.
4. Test the module using an example configuration.
5. Commit the changes.
6. Create a Git tag for a new release.
7. Publish the module for reuse.

---

## Additional Notes

* The `.terraform/` directory contains downloaded providers and temporary files. It should not be committed to version control.
* For reusable module repositories, `.terraform.lock.hcl` is often excluded from version control.
* Store secrets in secure systems such as environment variables or secret managers instead of hardcoding them in Terraform files.
