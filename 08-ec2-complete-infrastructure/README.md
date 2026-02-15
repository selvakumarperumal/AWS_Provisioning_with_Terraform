# 08 - EC2 Complete Infrastructure

## Overview

This is the **capstone project** — a production-grade AWS infrastructure combining **every concept** from the previous projects into one deployment.

**What gets created:**
- VPC with DNS support
- 2 Public subnets + 2 Private subnets (across 2 AZs)
- Internet Gateway for public internet access
- NAT Gateway + Elastic IP for private subnet outbound
- Public & Private route tables with associations
- Security Group (SSH + HTTP + HTTPS)
- SSH Key Pair
- EC2 instance (Apache web server) in public subnet

---

## Architecture

```mermaid
graph TB
    Internet["🌐 Internet"]

    subgraph AWS["☁️ AWS Cloud (Region: ap-south-2)"]
        subgraph VPC["🏗️ VPC (10.0.0.0/16)"]
            IGW["🚪 Internet Gateway<br/>(FREE, bidirectional)"]

            subgraph AZ_A["📍 AZ: ap-south-2a"]
                PubSub1["🟢 Public Subnet 1<br/>10.0.1.0/24"]
                PrivSub1["🔴 Private Subnet 1<br/>10.0.3.0/24"]
                NAT["🔄 NAT Gateway<br/>+ Elastic IP"]
            end

            subgraph AZ_B["📍 AZ: ap-south-2b"]
                PubSub2["🟢 Public Subnet 2<br/>10.0.2.0/24"]
                PrivSub2["🔴 Private Subnet 2<br/>10.0.4.0/24"]
            end

            PubRT["📋 Public Route Table<br/>0.0.0.0/0 → IGW"]
            PrivRT["📋 Private Route Table<br/>0.0.0.0/0 → NAT GW"]

            subgraph SG["🛡️ Security Group"]
                EC2["💻 EC2 Instance<br/>t3.micro | Apache2<br/>Public IP: auto"]
            end

            KP["🔑 SSH Key Pair"]
        end
    end

    Internet <-->|"Bidirectional"| IGW
    IGW --> PubRT
    PubRT --> PubSub1 & PubSub2
    PrivRT --> PrivSub1 & PrivSub2
    PubSub1 --> NAT
    NAT -.->|"Outbound only"| IGW
    EC2 --> PubSub1
    KP --> EC2

    style IGW fill:#ff9900,color:#000
    style NAT fill:#3b48cc,color:#fff
    style EC2 fill:#1a8f1a,color:#fff
    style SG fill:#dd3522,color:#fff
    style VPC fill:#232f3e,color:#fff
```

---

## Complete Traffic Flow

### Public Subnet Traffic (Web Server)

```mermaid
sequenceDiagram
    participant User as 🌐 User
    participant IGW as 🚪 IGW
    participant PubRT as 📋 Public RT
    participant SG as 🛡️ Security Group
    participant EC2 as 💻 EC2 (Apache)

    User->>IGW: HTTP request to public IP
    IGW->>PubRT: Route lookup
    PubRT->>SG: Forward to subnet
    SG->>SG: Port 80 allowed? ✅
    SG->>EC2: Deliver request
    EC2->>SG: Response (stateful = auto-allowed)
    SG->>IGW: Via public route table
    IGW->>User: HTTP response
```

### Private Subnet Traffic (DB Update)

```mermaid
sequenceDiagram
    participant DB as 🗄️ Private Instance<br/>(10.0.3.50)
    participant PrivRT as 📋 Private RT
    participant NAT as 🔄 NAT GW
    participant PubRT as 📋 Public RT
    participant IGW as 🚪 IGW
    participant Apt as 📦 Internet

    DB->>PrivRT: apt-get update
    Note over PrivRT: 0.0.0.0/0 → NAT GW
    PrivRT->>NAT: Forward
    Note over NAT: SNAT: 10.0.3.50 → EIP
    NAT->>PubRT: Forward
    Note over PubRT: 0.0.0.0/0 → IGW
    PubRT->>IGW: Forward
    IGW->>Apt: Request reaches internet
    Apt->>IGW: Response
    IGW->>NAT: Return to NAT
    Note over NAT: DNAT: EIP → 10.0.3.50
    NAT->>PrivRT: Forward
    PrivRT->>DB: Delivered!

    Note over Apt,DB: ❌ Internet CANNOT initiate connection to DB
```

---

## Module Dependency Graph

```mermaid
graph TD
    Root["terraform/main.tf"] --> VPC["modules/vpc"]
    Root --> Subnet["modules/subnet"]
    Root --> IGW["modules/igw"]
    Root --> NAT["modules/nat"]
    Root --> RT["modules/route-table"]
    Root --> SG["modules/security-group"]
    Root --> KP["aws_key_pair"]
    Root --> EC2["modules/ec2"]

    VPC -->|"vpc_id"| Subnet & IGW & NAT & RT & SG
    Subnet -->|"public_subnet_ids"| RT & EC2
    Subnet -->|"private_subnet_ids"| RT
    Subnet -->|"public_subnet_ids[0]"| NAT
    IGW -->|"igw_id"| RT & NAT
    NAT -->|"nat_gateway_id"| RT
    SG -->|"security_group_id"| EC2
    KP -->|"key_name"| EC2

    EC2 -->|"public_ip"| Output["📋 Outputs"]

    style Root fill:#ff9900,color:#000
    style NAT fill:#3b48cc,color:#fff
    style IGW fill:#1a8f1a,color:#fff
    style Output fill:#9c27b0,color:#fff
```

---

## Resources Created (Total: 15)

| # | Resource | Module | Purpose |
|---|----------|--------|---------|
| 1 | `aws_vpc` | vpc | Isolated network |
| 2-3 | `aws_subnet` (public ×2) | subnet | Internet-facing subnets |
| 4-5 | `aws_subnet` (private ×2) | subnet | Internal subnets |
| 6 | `aws_internet_gateway` | igw | VPC internet access |
| 7 | `aws_eip` | nat | Static IP for NAT |
| 8 | `aws_nat_gateway` | nat | Private subnet outbound |
| 9 | `aws_route_table` (public) | route-table | Public routes |
| 10 | `aws_route_table` (private) | route-table | Private routes |
| 11-12 | `aws_route_table_association` (×2) | route-table | Link subnets to RTs |
| 13 | `aws_security_group` | security-group | Firewall rules |
| 14 | `aws_key_pair` | root | SSH access |
| 15 | `aws_instance` | ec2 | Web server |

---

## Terraform Concepts Used

### `count` — Create Multiple Subnets

```hcl
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
}
```

### `element()` — Cycle Through Lists

```hcl
availability_zone = element(var.azs, count.index)
# If azs = ["2a", "2b"] and count.index = 2, wraps to "2a"
```

### `[*]` — Splat Expression

```hcl
output "subnet_ids" {
  value = aws_subnet.public[*].id
  # Returns ALL subnet IDs as a list
}
```

### `depends_on` — Explicit Dependencies

```hcl
resource "aws_nat_gateway" "nat" {
  depends_on = [var.igw_id]
  # NAT won't work without IGW existing first
}
```

---

## File Structure

```
08-ec2-complete-infrastructure/
├── README.md                    ← You are here
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── subnet/
│   │   ├── main.tf              ← 2 public + 2 private subnets (count)
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── igw/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── nat/
│   │   ├── main.tf              ← EIP + NAT Gateway
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── route-table/
│   │   ├── main.tf              ← Public RT + Private RT + Associations
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security-group/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2/
│       ├── main.tf              ← EC2 + user_data (Apache)
│       ├── variables.tf
│       └── outputs.tf
└── terraform/
    ├── main.tf                  ← Orchestrates all modules
    ├── variables.tf
    ├── outputs.tf
    ├── providers.tf
    └── terraform.tfvars.example
```

---

## Usage

```bash
# 1. Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/aws_key

# 2. Set up variables
cd terraform/
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars

# 3. Deploy
terraform init
terraform plan
terraform apply

# 4. Access your server
ssh -i ~/.ssh/aws_key ubuntu@<PUBLIC_IP>
curl http://<PUBLIC_IP>

# 5. Clean up (avoid charges!)
terraform destroy
```

> **Cost Warning:** NAT Gateway costs ~$0.045/hr. Always destroy when done testing!

---

## What You've Learned

After completing all 8 projects, you now understand:

```mermaid
graph TD
    A["🎓 AWS + Terraform Mastery"]
    A --> B["Networking"]
    A --> C["Compute"]
    A --> D["Terraform"]

    B --> B1["VPC & CIDR"]
    B --> B2["Subnets & AZs"]
    B --> B3["Internet Gateway"]
    B --> B4["NAT Gateway & EIP"]
    B --> B5["Route Tables"]
    B --> B6["Security Groups"]

    C --> C1["EC2 Instances"]
    C --> C2["AMIs & Instance Types"]
    C --> C3["Key Pairs & SSH"]
    C --> C4["User Data Bootstrap"]

    D --> D1["Modules"]
    D --> D2["Variables & Outputs"]
    D --> D3["count & element()"]
    D --> D4["depends_on"]
    D --> D5["Splat expressions"]

    style A fill:#ff9900,color:#000
    style B fill:#3b48cc,color:#fff
    style C fill:#1a8f1a,color:#fff
    style D fill:#9c27b0,color:#fff
```
