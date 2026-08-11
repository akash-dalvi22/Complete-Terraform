# Day 05 - Conditional Expression, Dynamic Block, and Splat Expression

This file explains three important Terraform concepts in a practical and professional way. These features are commonly used in real-world infrastructure code to make configurations flexible, reusable, and easier to manage.

## 1. Conditional Expression

A conditional expression allows you to choose one value or another based on a condition.

### Syntax

```hcl
condition ? true_value : false_value
```

### Example

```hcl
instance_type = var.environment == "dev" ? "t2.micro" : "t2.medium"
```

### What this means

- If `var.environment` is `dev`, Terraform uses `t2.micro`
- Otherwise, it uses `t2.medium`

### Why it is useful

This is helpful when you want to avoid hardcoding values and make the configuration adapt to different environments such as development, staging, or production.

### Best practices

- Use it for simple decision-making
- Keep the expression readable
- Avoid overly complex nested conditions when a variable or module is a better option

---

## 2. Dynamic Block

A dynamic block is used when you want to generate repeated nested blocks inside a resource based on input data.

### Why use it

Instead of manually writing many similar blocks, Terraform can create them dynamically from a list or map.

### Example

```hcl
dynamic "ingress" {
  for_each = var.ingress_rules
  content {
    from_port   = ingress.value.from_port
    to_port     = ingress.value.to_port
    protocol    = ingress.value.protocol
    cidr_blocks = ingress.value.cidr_blocks
  }
}
```

### What this means

- Terraform iterates through `var.ingress_rules`
- It creates one `ingress` block for each rule
- This is especially useful for resources like security groups, IAM policies, and other repeated configuration blocks

### Why this is important in real projects

Dynamic blocks are widely used in production Terraform code because they reduce duplication and make configurations easier to scale.

### Best practices

- Use dynamic blocks when the number of blocks may vary
- Keep the input data structured and predictable
- Use them to simplify repetitive configuration rather than overcomplicate the code

---

## 3. Splat Expression

A splat expression allows you to access a field from a list of objects in a compact way.

### Syntax

```hcl
resource_type.example[*].attribute
```

### Example

```hcl
values = aws_instance.example[*].id
```

### What this means

If multiple instances exist, Terraform collects all their IDs into a list.

### Why it is useful

This is very helpful when you need to gather output values from several resources without writing a long loop.

### In real-world use cases

Splat expressions are often used when:
- collecting IDs from multiple resources
- passing several values to another resource
- building lists for outputs or modules

### Best practices

- Use splat expressions when working with lists of objects
- Keep the structure of the data clear and consistent
- Combine them with `for` expressions when more transformation is needed

---

## Practical Comparison

Here is a quick summary of when to use each concept:

- Use a conditional expression when you need simple decision-making
- Use a dynamic block when you need to create repeated nested blocks from data
- Use a splat expression when you need values from a collection of resources

---

## Beginner and Intermediate Notes

- Conditional expressions are like simple `if-else` logic in Terraform
- Dynamic blocks help create repeated blocks automatically
- Splat expressions help collect values from many resources quickly

## Professional Takeaway

These three concepts are essential in real-world Terraform code because they help make configurations:

- more flexible
- less repetitive
- easier to maintain
- suitable for large and complex infrastructures

In practice, experienced engineers use them to write cleaner and more scalable infrastructure as code.
