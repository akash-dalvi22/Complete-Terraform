# 🚀 Terraform Provisioners

> **Day 14 focus:** Run commands, transfer files, and understand when provisioners
> are appropriate in a DevOps workflow.

**Quick navigation:** [Types](#-provisioner-types) · [Day 14 example](#-how-this-day-14-example-works) · [Behavior](#-important-terraform-behavior) · [Alternatives](#-recommended-alternatives) · [Interview notes](#-devops-and-interview-notes)

Provisioners allow Terraform to run commands or copy files during the creation or
destruction of infrastructure. They are useful when a resource provider does not
expose a required action, but they should be used carefully because Terraform is
primarily designed to manage infrastructure, not to configure operating systems.

> ⚠️ **Remember:** Provisioners are a last resort. Prefer declarative Terraform
> resources, cloud-init, or configuration-management tools whenever possible.

## 🧰 Provisioner Types

### 1. 💻 `local-exec`

Runs a command on the machine where Terraform is executed. That machine may be a
developer laptop, a CI/CD runner, or an automation host.

```hcl
provisioner "local-exec" {
	command = "echo 'Created ${self.id}'"
}
```

Common uses include writing an audit message, calling a local script, or triggering
an integration after a resource is created. The command must be available on the
machine running Terraform.

### 2. 🌐 `remote-exec`

Runs commands on a remote machine through a `connection` block.

```hcl
connection {
	type        = "ssh"
	user        = var.ssh_user
	private_key = file(var.private_key_path)
	host        = self.public_ip
}

provisioner "remote-exec" {
	inline = [
		"sudo apt-get update",
		"sudo apt-get install -y nginx",
	]
}
```

`remote-exec` requires all of the following:

- ✅ The instance is running and has a reachable IP address.
- ✅ The security group, firewall, and network ACL allow SSH on port 22.
- ✅ The key pair exists in the selected AWS region.
- ✅ The private key path and SSH username are correct.
- ✅ The remote user has permission to run the commands.

### 3. 📦 `file`

Copies a local file or directory to a remote machine. It also requires a
`connection` block.

```hcl
provisioner "file" {
	source      = "${path.module}/scripts/welcome.sh"
	destination = "/tmp/welcome.sh"
}
```

The `file` provisioner only copies the file; use `remote-exec` if it also needs to
be made executable and run:

```hcl
provisioner "remote-exec" {
	inline = [
		"chmod +x /tmp/welcome.sh",
		"sudo /tmp/welcome.sh",
	]
}
```

## 🔍 How This Day 14 Example Works

The configuration creates an Ubuntu EC2 instance and an SSH security group. The
provisioner blocks in `main.tf` are examples that can be enabled one at a time:

1. 💻 `local-exec` runs on the computer or CI runner running Terraform.
2. 🌐 `remote-exec` connects to the Ubuntu instance and runs inline shell commands.
3. 📦 `file` uploads `scripts/welcome.sh`; a second `remote-exec` block runs it.

### 🔐 Configure Before Applying

Provide values similar to these in `terraform.tfvars`:

```hcl
key_name         = "my-existing-aws-key"
private_key_path = "C:/Users/<your-user>/.ssh/my-existing-aws-key.pem"
ssh_user         = "ubuntu"
instance_type    = "t3.micro"
```

### ▶️ Run the Example

Run the example from this directory:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

> 🔒 **Security warning:** The private key is sensitive. Do not commit it, place it
> in `terraform.tfvars`, or print it in logs. The example security group allows SSH
> from `0.0.0.0/0` for demonstration only. In a real environment, restrict port 22
> to a trusted office IP, VPN, bastion host, or CI runner.

## ⚙️ Important Terraform Behavior

- 🔁 Provisioners run only when Terraform creates or replaces a resource, so changing
	  a command does not always run it again.
- 🧾 Terraform records resource state, but it does not record every command result or
	  manage configuration drift created by a script.
- ❌ A failed provisioner normally causes the apply to fail. Use
	  `on_failure = continue` only when ignoring the failure is intentional and
	  documented.
- 🧩 Provisioners can be attached to a resource or declared as a `terraform_data`
	  resource when the action is not naturally owned by a cloud resource.
- 🗑️ A `when = destroy` provisioner runs during destruction and must be written with
	  care because the resource may already be partly unavailable.
- 🎯 Use `self` to refer to the resource hosting the provisioner. Avoid referring to
	  the resource by its own address inside the block because that can create a
	  dependency cycle.

## 🛠️ Recommended Alternatives

Prefer these approaches when they meet the requirement:

- ☁️ Use cloud-init or `user_data` for first-boot Linux configuration.
- 🏗️ Use an image-building tool such as Packer for repeatable machine images.
- 🔧 Use Ansible, Chef, or another configuration-management tool for ongoing server
	  configuration.
- ✅ Use native Terraform resources and provider arguments whenever a provider
	  supports the required feature.

Provisioners are a last-mile integration tool. They are reasonable for a small
bootstrap action, a provider gap, or a learning demonstration, but large setup
scripts become difficult to retry, test, audit, and maintain inside Terraform.

## 🎓 DevOps and Interview Notes

- 💻 `local-exec` executes locally; 🌐 `remote-exec` executes remotely; 📦 `file`
	  transfers files remotely.
- 🔌 `remote-exec` and `file` need a valid connection; `local-exec` does not.
- 🧠 Provisioners are imperative, while Terraform resources are declarative.
- 🔁 Provisioners are not idempotent automatically. Write scripts so that running
	  them more than once is safe.
- 🔒 Never hard-code credentials or private keys. Use variables, a secrets manager,
	  CI/CD secret storage, and least-privilege access.
- 🧪 Test provisioner commands independently on a disposable instance before adding
	  them to a production module.


