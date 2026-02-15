# 02 - Subnets

## What is a Subnet?

A **Subnet** (sub-network) is a range of IP addresses within your VPC. Subnets let you divide your VPC into smaller, isolated sections — each placed in a specific **Availability Zone (AZ)**.

> Think of VPC as a building, and subnets as rooms inside that building. Each room is in a specific floor (AZ).

---

## Architecture

```mermaid
graph TB
    subgraph AWS["☁️ AWS Cloud (Region: ap-south-2)"]
        subgraph VPC["🏗️ VPC (10.0.0.0/16)"]
            subgraph AZ["📍 Availability Zone: ap-south-2a"]
                Subnet["🔲 Subnet<br/>10.0.1.0/24<br/>251 usable IPs<br/>Public IP auto-assign: ON"]
            end
        end
    end

    style VPC fill:#232f3e,color:#fff
    style Subnet fill:#3b48cc,color:#fff
    style AZ fill:#1a472a,color:#fff
```

---

## Key Concepts

### What is an Availability Zone (AZ)?

Each AWS Region has multiple isolated data centers called Availability Zones.

```mermaid
graph TB
    subgraph Region["Region: ap-south-2 (Hyderabad)"]
        AZ_A["AZ: ap-south-2a<br/>Data Center A"]
        AZ_B["AZ: ap-south-2b<br/>Data Center B"]
        AZ_C["AZ: ap-south-2c<br/>Data Center C"]
    end

    AZ_A <-->|"Low latency link"| AZ_B
    AZ_B <-->|"Low latency link"| AZ_C

    style Region fill:#ff9900,color:#000
```

| Term | What It Is | Example |
|------|-----------|---------|
| **Region** | Geographic area with multiple data centers | `ap-south-2` (Hyderabad) |
| **AZ** | Isolated data center within a region | `ap-south-2a` |
| **Subnet** | IP range placed in ONE specific AZ | `10.0.1.0/24` in `ap-south-2a` |

### Subnet CIDR Planning

When you have a VPC with `10.0.0.0/16`, you can split it into subnets:

```mermaid
graph TB
    VPC["VPC: 10.0.0.0/16<br/>(65,536 IPs)"]
    VPC --> S1["Subnet 1: 10.0.1.0/24<br/>(256 IPs)"]
    VPC --> S2["Subnet 2: 10.0.2.0/24<br/>(256 IPs)"]
    VPC --> S3["Subnet 3: 10.0.3.0/24<br/>(256 IPs)"]
    VPC --> S4["...up to 256 subnets"]

    style VPC fill:#232f3e,color:#fff
    style S1 fill:#3b48cc,color:#fff
    style S2 fill:#3b48cc,color:#fff
    style S3 fill:#3b48cc,color:#fff
```

### `map_public_ip_on_launch`

| Value | Effect |
|-------|--------|
| `true` | Every EC2 launched in this subnet gets a public IP automatically |
| `false` | EC2 instances only get private IPs (need Elastic IP for public access) |

> **Note:** This alone doesn't give internet access. You also need an Internet Gateway + Route Table (covered in [04-internet-gateway](../04-internet-gateway/)).

---

## Module Dependencies

```mermaid
graph LR
    VPC["modules/vpc"] -->|"vpc_id"| Subnet["modules/subnet"]
    
    subgraph Inputs
        CI["vpc_cidr"]
        SC["subnet_cidr"]
        AZ2["availability_zone"]
    end
    
    CI --> VPC
    SC --> Subnet
    AZ2 --> Subnet

    style VPC fill:#ff9900,color:#000
    style Subnet fill:#3b48cc,color:#fff
```

---

## File Structure

```
02-subnets/
├── README.md                    ← You are here
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── subnet/
│       ├── main.tf              ← Subnet resource
│       ├── variables.tf         ← Inputs: vpc_id, cidr, AZ
│       └── outputs.tf           ← Output: subnet_id, name
└── terraform/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── providers.tf
    └── terraform.tfvars.example
```

---

## Usage

```bash
cd terraform/
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

---

## What's Next?

➡️ [03-public-private-subnets](../03-public-private-subnets/) — Create separate public and private subnets for network isolation.
