# 03 - Public & Private Subnets

## What's the Difference?

In AWS, subnets are not inherently "public" or "private" — it depends on their **routing configuration**. But architecturally, we design them differently:

| Feature | Public Subnet | Private Subnet |
|---------|--------------|----------------|
| **Purpose** | Host internet-facing resources | Host internal/backend resources |
| **Internet access** | Bidirectional (via IGW) | Outbound only (via NAT) or none |
| **Public IP** | Auto-assigned or Elastic IP | Not assigned |
| **Examples** | Web servers, bastion hosts, ALBs | Databases, app servers, caches |
| **Security** | Exposed (protected by SG/NACL) | Hidden from internet |

---

## Architecture

```mermaid
graph TB
    subgraph AWS["☁️ AWS Cloud (Region: ap-south-2)"]
        subgraph VPC["🏗️ VPC (10.0.0.0/16)"]
            subgraph AZ_A["📍 AZ: ap-south-2a"]
                PubSub["🟢 Public Subnet<br/>10.0.1.0/24<br/>━━━━━━━━━━━━<br/>Web Servers<br/>Load Balancers<br/>Bastion Hosts"]
            end
            subgraph AZ_B["📍 AZ: ap-south-2b"]
                PrivSub["🔴 Private Subnet<br/>10.0.2.0/24<br/>━━━━━━━━━━━━<br/>Databases<br/>App Servers<br/>Internal Services"]
            end
        end
    end

    Internet["🌐 Internet"] -->|"✅ Can reach"| PubSub
    Internet -->|"❌ Cannot reach"| PrivSub

    style VPC fill:#232f3e,color:#fff
    style PubSub fill:#1a8f1a,color:#fff
    style PrivSub fill:#dd3522,color:#fff
```

---

## Why Separate Public and Private?

```mermaid
graph TD
    A["Why separate subnets?"] --> B["🔒 Security"]
    A --> C["📋 Compliance"]
    A --> D["💰 Cost"]
    A --> E["🏗️ Architecture"]

    B --> B1["Databases shouldn't<br/>be internet-accessible"]
    C --> C1["PCI/HIPAA require<br/>network isolation"]
    D --> D1["Less public IPs needed<br/>= less attack surface"]
    E --> E1["Clean separation of<br/>frontend vs backend"]

    style A fill:#ff9900,color:#000
```

### Common Architecture Pattern (3-Tier)

```mermaid
graph TB
    Internet["🌐 Internet"]
    
    subgraph VPC["VPC"]
        subgraph Public["Public Subnet"]
            ALB["Application<br/>Load Balancer"]
            Bastion["Bastion Host<br/>(Jump Box)"]
        end
        
        subgraph Private_App["Private Subnet (App Tier)"]
            App1["App Server 1"]
            App2["App Server 2"]
        end
        
        subgraph Private_DB["Private Subnet (Data Tier)"]
            RDS["RDS Database"]
            Redis["ElastiCache<br/>(Redis)"]
        end
    end

    Internet --> ALB
    Internet --> Bastion
    ALB --> App1
    ALB --> App2
    Bastion -->|SSH| App1
    Bastion -->|SSH| App2
    App1 --> RDS
    App2 --> RDS
    App1 --> Redis

    style Public fill:#1a8f1a,color:#fff
    style Private_App fill:#ff9900,color:#000
    style Private_DB fill:#dd3522,color:#fff
```

---

## Multi-AZ Design for High Availability

```mermaid
graph TB
    subgraph VPC["VPC (10.0.0.0/16)"]
        subgraph AZ_A["AZ-A"]
            PubA["Public 10.0.1.0/24"]
            PrivA["Private 10.0.3.0/24"]
        end
        subgraph AZ_B["AZ-B"]
            PubB["Public 10.0.2.0/24"]
            PrivB["Private 10.0.4.0/24"]
        end
    end

    Note["If AZ-A goes down,<br/>AZ-B keeps running!"]

    style AZ_A fill:#1a472a,color:#fff
    style AZ_B fill:#1a472a,color:#fff
    style Note fill:#fff3cd,color:#000
```

> **Best Practice:** Always deploy across at least 2 AZs for fault tolerance.

---

## Module Dependencies

```mermaid
graph LR
    VPC["modules/vpc"] -->|"vpc_id"| Subnet["modules/subnet"]

    subgraph Subnet_Creates["Subnet Module Creates"]
        PS["Public Subnet"]
        PrS["Private Subnet"]
    end

    style VPC fill:#ff9900,color:#000
    style Subnet fill:#3b48cc,color:#fff
```

---

## File Structure

```
03-public-private-subnets/
├── README.md                    ← You are here
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── subnet/
│       ├── main.tf              ← Creates BOTH public & private subnets
│       ├── variables.tf
│       └── outputs.tf
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

➡️ [04-internet-gateway](../04-internet-gateway/) — Connect your public subnet to the internet with an Internet Gateway.
