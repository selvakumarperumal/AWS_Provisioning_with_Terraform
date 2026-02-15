# 11 - Application Load Balancer (ALB)

## Overview

An **Application Load Balancer (ALB)** distributes incoming HTTP/HTTPS traffic across multiple EC2 instances. It operates at **Layer 7** (application layer), enabling path-based and host-based routing.

---

## How ALB Works

```mermaid
graph TB
    Users["🌐 Users"]

    subgraph VPC["VPC (10.0.0.0/16)"]
        IGW["🚪 Internet Gateway"]

        subgraph ALB_Layer["Application Load Balancer"]
            ALB["⚖️ ALB<br/>(Public, Multi-AZ)"]
            Listener["👂 Listener<br/>Port 80 (HTTP)"]
            TG["🎯 Target Group<br/>Health Check: /"]
        end

        subgraph AZ1["AZ: ap-south-2a"]
            PubSub1["Public Subnet 1<br/>10.0.1.0/24"]
            EC2_1["💻 EC2 #1<br/>Apache"]
        end

        subgraph AZ2["AZ: ap-south-2b"]
            PubSub2["Public Subnet 2<br/>10.0.2.0/24"]
            EC2_2["💻 EC2 #2<br/>Apache"]
        end
    end

    Users --> IGW --> ALB
    ALB --> Listener
    Listener --> TG
    TG -->|"Round Robin"| EC2_1
    TG -->|"Round Robin"| EC2_2

    style ALB fill:#ff9900,color:#000
    style TG fill:#3b48cc,color:#fff
    style EC2_1 fill:#1a8f1a,color:#fff
    style EC2_2 fill:#1a8f1a,color:#fff
```

---

## ALB Components

```mermaid
graph LR
    subgraph Components["ALB Components"]
        LB["⚖️ Load Balancer<br/>(Entry point, DNS name)"]
        L["👂 Listener<br/>(Port + Protocol)"]
        R["📋 Rules<br/>(Path/host conditions)"]
        TG["🎯 Target Group<br/>(Backend servers)"]
        HC["❤️ Health Check<br/>(Is target healthy?)"]
    end

    LB --> L --> R --> TG --> HC

    style LB fill:#ff9900,color:#000
    style L fill:#3b48cc,color:#fff
    style TG fill:#1a8f1a,color:#fff
    style HC fill:#dd3522,color:#fff
```

| Component | What It Does |
|-----------|-------------|
| **Load Balancer** | Entry point — gets a DNS name (e.g., `my-alb-123.ap-south-2.elb.amazonaws.com`) |
| **Listener** | Listens on a port (80, 443) and routes to target groups |
| **Rules** | Conditions for routing (path `/api/*`, host `api.example.com`) |
| **Target Group** | Collection of backend targets (EC2s, IPs, Lambdas) |
| **Health Check** | Periodically checks target health (`/` every 30s) |

---

## Types of Load Balancers

| Type | Layer | Best For | Protocol |
|------|-------|----------|----------|
| **ALB** | Layer 7 | HTTP/HTTPS, microservices, path routing | HTTP, HTTPS, gRPC |
| **NLB** | Layer 4 | Ultra-high performance, TCP/UDP | TCP, UDP, TLS |
| **CLB** | Layer 4/7 | Legacy (don't use for new) | HTTP, TCP |
| **GWLB** | Layer 3 | Third-party appliances | GENEVE |

---

## Path-Based Routing

```mermaid
graph TB
    ALB["⚖️ ALB"]

    ALB -->|"/api/*"| TG_API["🎯 API Target Group<br/>EC2: API servers"]
    ALB -->|"/images/*"| TG_IMG["🎯 Images Target Group<br/>EC2: Image servers"]
    ALB -->|"/* (default)"| TG_WEB["🎯 Web Target Group<br/>EC2: Web servers"]

    style ALB fill:#ff9900,color:#000
    style TG_API fill:#3b48cc,color:#fff
    style TG_IMG fill:#1a8f1a,color:#fff
    style TG_WEB fill:#9c27b0,color:#fff
```

---

## Health Check Flow

```mermaid
sequenceDiagram
    participant ALB as ⚖️ ALB
    participant EC2_1 as 💻 EC2 #1
    participant EC2_2 as 💻 EC2 #2

    loop Every 30 seconds
        ALB->>EC2_1: GET / (health check)
        EC2_1->>ALB: 200 OK ✅ (healthy)

        ALB->>EC2_2: GET / (health check)
        EC2_2->>ALB: 503 Error ❌ (unhealthy)
    end

    Note over ALB: Remove EC2 #2 from rotation

    ALB->>EC2_1: Route ALL traffic here
    ALB--xEC2_2: No traffic sent

    Note over EC2_2: After 3 consecutive 200s...
    EC2_2->>ALB: 200 OK ✅✅✅

    Note over ALB: EC2 #2 back in rotation!
```

---

## Security Groups for ALB

```mermaid
graph LR
    Internet["🌐 Internet"]

    subgraph ALB_SG["ALB Security Group"]
        ALB["⚖️ ALB<br/>Inbound: 80, 443 from 0.0.0.0/0"]
    end

    subgraph EC2_SG["EC2 Security Group"]
        EC2["💻 EC2<br/>Inbound: 80 from ALB SG ONLY"]
    end

    Internet -->|"Port 80/443"| ALB
    ALB -->|"Port 80"| EC2

    style ALB_SG fill:#ff9900,color:#000
    style EC2_SG fill:#1a8f1a,color:#fff
```

> **Best Practice:** EC2 instances should ONLY accept traffic from the ALB security group — not directly from the internet.

---

## What Gets Created

| # | Resource | Purpose |
|---|----------|---------|
| 1 | `aws_vpc` | Network |
| 2-3 | `aws_subnet` (×2 AZs) | ALB needs ≥2 AZs |
| 4 | `aws_internet_gateway` | Internet access |
| 5 | `aws_route_table` + associations | Public routing |
| 6 | `aws_security_group` (ALB) | ALB firewall |
| 7 | `aws_security_group` (EC2) | EC2 firewall (ALB-only) |
| 8 | `aws_lb` | Application Load Balancer |
| 9 | `aws_lb_target_group` | Backend targets |
| 10 | `aws_lb_listener` | Port 80 listener |
| 11-12 | `aws_instance` (×2) | Web servers |
| 13-14 | `aws_lb_target_group_attachment` (×2) | Register EC2s |

---

## File Structure

```
11-load-balancer/
├── README.md
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── network/
│   │   ├── main.tf         ← Subnets, IGW, Route Tables
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security-group/
│   │   ├── main.tf         ← ALB SG + EC2 SG
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── alb/
│   │   ├── main.tf         ← ALB, Target Group, Listener
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2/
│       ├── main.tf         ← 2 EC2 instances + TG attachments
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

## Cost

| Resource | Cost |
|----------|------|
| ALB | ~$0.0225/hr + $0.008/LCU-hr |
| EC2 (t3.micro ×2) | ~$0.0104/hr each |
| Data transfer | $0.09/GB (outbound) |

> **Always `terraform destroy` when done testing!**
