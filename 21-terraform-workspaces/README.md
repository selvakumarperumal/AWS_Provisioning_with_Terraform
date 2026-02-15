# Project 21: Terraform Workspaces

## Concepts Covered

- Terraform workspaces for multi-environment management
- `terraform.workspace` interpolation
- Environment-specific variables with `lookup()`
- Workspace-aware resource naming
- State isolation per environment
- `terraform workspace` CLI commands

---

## Architecture

```mermaid
graph TB
    subgraph Workspaces["Terraform Workspaces"]
        Dev["dev workspace"]
        Staging["staging workspace"]
        Prod["prod workspace"]
    end

    subgraph State["State Files (Isolated)"]
        DevState["terraform.tfstate.d/dev/"]
        StagingState["terraform.tfstate.d/staging/"]
        ProdState["terraform.tfstate.d/prod/"]
    end

    subgraph AWS["AWS Resources"]
        subgraph DevEnv["dev"]
            DevVPC["VPC: 10.0.0.0/16<br/>t3.micro"]
        end
        subgraph StagingEnv["staging"]
            StagingVPC["VPC: 10.1.0.0/16<br/>t3.small"]
        end
        subgraph ProdEnv["prod"]
            ProdVPC["VPC: 10.2.0.0/16<br/>t3.medium"]
        end
    end

    Dev --> DevState --> DevEnv
    Staging --> StagingState --> StagingEnv
    Prod --> ProdState --> ProdEnv

    style Dev fill:#1a8f1a,color:#fff
    style Staging fill:#ff9900,color:#000
    style Prod fill:#dd3522,color:#fff
    style DevVPC fill:#3b48cc,color:#fff
    style StagingVPC fill:#3b48cc,color:#fff
    style ProdVPC fill:#3b48cc,color:#fff
```

---

## Workspace Flow

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant TF as Terraform
    participant State as State Storage
    participant AWS as AWS

    Dev->>TF: terraform workspace new dev
    TF->>State: Create state: tfstate.d/dev/
    Dev->>TF: terraform apply
    TF->>TF: workspace = "dev"
    TF->>TF: Lookup dev config
    TF->>AWS: Create: dev-vpc (10.0.0.0/16)
    
    Dev->>TF: terraform workspace new prod
    TF->>State: Create state: tfstate.d/prod/
    Dev->>TF: terraform apply
    TF->>TF: workspace = "prod"
    TF->>TF: Lookup prod config
    TF->>AWS: Create: prod-vpc (10.2.0.0/16)

    Note over Dev,AWS: Same code, different environments!
```

---

## Key Concepts

### Workspace CLI Commands

| Command | Description |
|---------|-------------|
| `terraform workspace list` | List all workspaces |
| `terraform workspace new <name>` | Create a new workspace |
| `terraform workspace select <name>` | Switch to a workspace |
| `terraform workspace show` | Show current workspace |
| `terraform workspace delete <name>` | Delete a workspace |

### Using `terraform.workspace`

```hcl
# Access current workspace name
locals {
  environment = terraform.workspace
}

# Environment-specific config via lookup
locals {
  vpc_cidr = lookup({
    dev     = "10.0.0.0/16"
    staging = "10.1.0.0/16"
    prod    = "10.2.0.0/16"
  }, terraform.workspace, "10.0.0.0/16")
}

# Prefix resource names
resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr
  tags = {
    Name = "${terraform.workspace}-vpc"
  }
}
```

### Workspaces vs Separate Directories

| Feature | Workspaces | Separate Dirs |
|---------|-----------|---------------|
| Code duplication | None (shared) | Full copy per env |
| State isolation | Automatic | Manual |
| Config differences | `lookup()` / conditionals | Separate `.tfvars` |
| Best for | Similar environments | Very different environments |
| Team workflows | Simple projects | Complex organizations |

### When to Use Workspaces

| Use | Avoid |
|-----|-------|
| Dev / Staging / Prod with same infra | Completely different architectures per env |
| Quick environment spin-up/teardown | Enterprise multi-team setups |
| Personal dev sandboxes | When environments diverge significantly |

---

## Resources Created (Per Workspace)

| Resource | Purpose |
|----------|---------|
| `aws_vpc` | VPC with workspace-specific CIDR |
| `aws_subnet` | Subnet with workspace-specific config |
| `aws_internet_gateway` | IGW for internet access |
| `aws_route_table` | Routing for the subnet |
| `aws_security_group` | SG with workspace-specific rules |

---

## Outputs

| Output | Description |
|--------|-------------|
| `workspace` | Current workspace name |
| `vpc_id` | VPC ID for this workspace |
| `vpc_cidr` | VPC CIDR for this workspace |
| `instance_type` | Instance type for this workspace |
