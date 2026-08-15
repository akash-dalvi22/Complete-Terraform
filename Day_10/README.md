# Terraform Data Sources

## Overview

Data sources in Terraform allow you to fetch and reference information from existing infrastructure or external systems without managing them as Terraform resources. They enable you to retrieve real-time data from your cloud provider, external APIs, or local systems for use in your Terraform configurations.

---

## Key Concepts

### What are Data Sources?

Data sources are read-only resources that allow Terraform to:
- Query existing infrastructure
- Fetch dynamic information from cloud providers
- Reference external data
- Avoid hardcoding values
- Maintain DRY (Don't Repeat Yourself) principles

### Resource vs Data Source

| Aspect | Resource | Data Source |
|--------|----------|-------------|
| Creates/Destroys | Yes | No |
| State Management | Stored in state file | Not stored in state |
| Syntax | `resource "type" "name"` | `data "type" "name"` |
| Use Case | Infrastructure provisioning | Data lookup/reference |
| Lifecycle | Full management | Read-only |

---

## Common Data Sources by Provider

### AWS Data Sources Examples

**1. Fetch Latest AMI ID**
```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

**2. Reference Existing VPC**
```hcl
data "aws_vpc" "default" {
  default = true
}

# Use in resource
resource "aws_security_group" "example" {
  vpc_id = data.aws_vpc.default.id
}
```

**3. Query Availability Zones**
```hcl
data "aws_availability_zones" "available" {
  state = "available"
}

# Use in resource
resource "aws_subnet" "example" {
  availability_zone = data.aws_availability_zones.available.names[0]
  # ... other configuration
}
```

**4. Fetch Caller Account Information**
```hcl
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  caller_arn = data.aws_caller_identity.current.arn
}
```

**5. Reference Existing Subnets**
```hcl
data "aws_subnets" "private" {
  filter {
    name   = "tag:Tier"
    values = ["Private"]
  }
}
```

### Other Common Data Sources

**Local File Data Source**
```hcl
data "local_file" "ssh_key" {
  filename = "~/.ssh/id_rsa.pub"
}

output "public_key" {
  value = data.local_file.ssh_key.content
}
```

**External Data Source**
```hcl
data "external" "example" {
  program = ["python", "${path.module}/scripts/fetch_data.py"]

  query = {
    key = "value"
  }
}
```

**HTTP Data Source**
```hcl
data "http" "example" {
  url = "https://api.example.com/data"

  request_headers = {
    Accept = "application/json"
  }
}
```

---

## Practical Examples

### Example 1: Multi-AZ EC2 Deployment

```hcl
# Fetch available AZs and latest AMI
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Create EC2 instances in multiple AZs
resource "aws_instance" "web" {
  count             = length(data.aws_availability_zones.available.names)
  ami               = data.aws_ami.ubuntu.id
  instance_type    = "t3.micro"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "web-server-${count.index + 1}"
  }
}
```

### Example 2: Conditional Configuration Based on Account ID

```hcl
data "aws_caller_identity" "current" {}

locals {
  is_production = data.aws_caller_identity.current.account_id == "123456789012"
  instance_type = local.is_production ? "t3.large" : "t3.micro"
}

resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = local.instance_type
}
```

### Example 3: Reference Existing Network Infrastructure

```hcl
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Environment"
    values = ["production"]
  }
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["Private"]
  }
}

resource "aws_security_group" "app" {
  name   = "app-sg"
  vpc_id = data.aws_vpc.selected.id
}
```

---

## Best Practices

### 1. **Use Descriptive Names**
```hcl
# ✅ Good - Clear purpose
data "aws_ami" "latest_amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  # ...
}

# ❌ Avoid - Vague name
data "aws_ami" "ami" {
  most_recent = true
  # ...
}
```

### 2. **Filter Efficiently**
```hcl
# ✅ Good - Specific filters reduce data fetched
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["Private"]
  }
}

# ❌ Avoid - Fetching all then filtering in locals
data "aws_subnets" "all" {}

locals {
  private_subnets = [for s in data.aws_subnets.all.ids : s if contains(keys(s), "private")]
}
```

### 3. **Use Depends_on for Complex Dependencies**
```hcl
data "aws_instance" "web" {
  # Reference instance created by Terraform
  depends_on = [aws_instance.web]

  filter {
    name   = "tag:Name"
    values = ["web-server"]
  }
}
```

### 4. **Cache Frequently Used Data**
```hcl
# Fetch once and reuse
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_caller_identity.current.account_id
}

# Use locals in multiple resources
resource "aws_s3_bucket" "logs" {
  bucket = "logs-${local.account_id}"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "/aws/lambda/app-${local.account_id}"
}
```

### 5. **Handle Missing Data Gracefully**
```hcl
# ✅ Good - Provide defaults
data "aws_vpc" "default" {
  default = true
}

variable "vpc_id" {
  type        = string
  description = "VPC ID (uses default if not provided)"
  default     = ""
}

locals {
  vpc_id = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default.id
}

# ❌ Avoid - Hard dependencies without fallback
resource "aws_security_group" "app" {
  vpc_id = var.vpc_id # Fails if not provided
}
```

### 6. **Document Data Source Requirements**
```hcl
# ✅ Good - Clear documentation
data "aws_ami" "ubuntu" {
  # This data source expects Ubuntu images to be available
  # in the current region. Requires: AWS account credentials
  # and appropriate IAM permissions (ec2:DescribeImages)
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-*"]
  }
}
```

### 7. **Use Splat Syntax Efficiently**
```hcl
# ✅ Good - Extract multiple IDs concisely
resource "aws_instance" "app" {
  count         = 3
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
}

output "instance_ids" {
  value = aws_instance.app[*].id
}

# ✅ Also good - Reference data sources
data "aws_subnets" "private" {
  filter {
    name   = "tag:Tier"
    values = ["Private"]
  }
}

resource "aws_instance" "app" {
  count             = length(data.aws_subnets.private.ids)
  subnet_id         = data.aws_subnets.private.ids[count.index]
  # ... other config
}
```

### 8. **Avoid Circular Dependencies**
```hcl
# ✅ Good - Clear data flow
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "app" {
  vpc_id = data.aws_vpc.default.id
}

# ❌ Avoid - Circular dependency
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

data "aws_vpc" "main" {
  # Don't query resource just created
  id = aws_vpc.main.id
}
```

### 9. **Use Data Sources for Cross-Stack References**
```hcl
# Stack A creates resources with tags
resource "aws_instance" "web" {
  ami = "ami-0c55b159cbfafe1f0"

  tags = {
    Stack = "web-server"
  }
}

# ============================================ #

# Stack B - References Stack A's resources
data "aws_instances" "web_servers" {
  filter {
    name   = "tag:Stack"
    values = ["web-server"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

resource "aws_lb_target_group_attachment" "web" {
  count            = length(data.aws_instances.web_servers.ids)
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = data.aws_instances.web_servers.ids[count.index]
  port             = 80
}
```

### 10. **Use For_each with Data Sources**
```hcl
# ✅ Good - Flexible mapping
data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }
}

resource "aws_route_table_association" "subnet" {
  for_each       = toset(data.aws_subnets.all.ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.main.id
}
```

---

## Common Use Cases

### 1. **Multi-Environment Deployments**
Use data sources to fetch region-specific or account-specific resources without duplicating code.

### 2. **Importing Existing Infrastructure**
Query existing resources to understand what's already provisioned before adding new infrastructure.

### 3. **Dynamic Resource Naming**
Use data sources like `aws_caller_identity` to ensure globally unique resource names.

### 4. **Network Configuration**
Fetch VPCs, subnets, and security groups to deploy applications into existing networks.

### 5. **Image Management**
Always use latest stable AMI without maintaining a hardcoded list.

### 6. **Cross-Stack Integration**
Reference resources created by other Terraform configurations using tags or naming conventions.

---

## Debugging Data Sources

### View Data Source Output
```hcl
# Use outputs to inspect data
output "vpc_info" {
  value = data.aws_vpc.default
}

output "available_azs" {
  value = data.aws_availability_zones.available.names
}
```

### Terraform Console
```bash
# Inspect data source results
terraform console
> data.aws_caller_identity.current.account_id
"123456789012"
> data.aws_ami.ubuntu.id
"ami-0c55b159cbfafe1f0"
```

### Terraform Plan
```bash
terraform plan -out=tfplan
# Review how data sources are being used
terraform show tfplan | grep data
```

---

## Key Takeaways

✅ **Do:**
- Use data sources to query existing infrastructure
- Implement robust filtering to get specific results
- Document IAM permissions required by data sources
- Cache frequently accessed data in locals
- Use for multi-environment and multi-region deployments

❌ **Don't:**
- Hardcode IDs when data sources can fetch them dynamically
- Create circular dependencies between resources and data sources
- Assume data sources are available in all regions
- Ignore authentication and permission errors

---

## Resources

- [Terraform Data Sources Documentation](https://www.terraform.io/language/data-sources)
- [AWS Provider Data Sources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources)
- [Terraform: Query Data Sources](https://learn.hashicorp.com/tutorials/terraform/resource-targeting)

---

**Last Updated:** 2026  
**Level:** Beginner to Advanced
