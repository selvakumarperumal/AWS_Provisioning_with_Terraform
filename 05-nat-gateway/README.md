# 05 - NAT Gateway

## What is a NAT Gateway?

A **NAT (Network Address Translation) Gateway** enables instances in a **private subnet** to initiate **outbound** connections to the internet (e.g., software updates, API calls) while **blocking all inbound** connections from the internet.

> **Simple analogy:** NAT Gateway is like a proxy. Private instances send requests through it. The internet sees the NAT Gateway's IP, never the private instance's IP. Replies come back through the NAT, but nobody can initiate a connection TO the private instance.

---

## Architecture

```mermaid
graph TB
    Internet["🌐 Internet<br/>(apt repos, APIs, etc.)"]

    subgraph AWS["☁️ AWS Cloud"]
        subgraph VPC["🏗️ VPC (10.0.0.0/16)"]
            IGW["🚪 Internet Gateway"]

            subgraph AZ_A["📍 AZ: ap-south-2a"]
                PubSub["🟢 Public Subnet<br/>10.0.1.0/24"]
                NAT["🔄 NAT Gateway<br/>━━━━━━━━━━━━━━━━━<br/>Elastic IP: 15.206.x.x<br/>Placed in PUBLIC subnet<br/>Enables OUTBOUND only"]
            end

            subgraph AZ_B["📍 AZ: ap-south-2b"]
                PrivSub["🔴 Private Subnet<br/>10.0.2.0/24"]
                DB["🗄️ Database Server<br/>10.0.2.50"]
                App["⚙️ App Server<br/>10.0.2.100"]
            end

            PubRT["📋 Public Route Table<br/>0.0.0.0/0 → IGW"]
            PrivRT["📋 Private Route Table<br/>0.0.0.0/0 → NAT Gateway"]
        end
    end

    Internet <-->|"Bidirectional"| IGW
    IGW --> PubRT --> PubSub
    PubSub --- NAT
    NAT -.->|"Outbound via"| IGW
    PrivRT --> PrivSub
    DB -->|"apt-get update"| PrivRT
    App -->|"API calls"| PrivRT

    Internet --x|"❌ BLOCKED<br/>Cannot initiate"| PrivSub

    style IGW fill:#ff9900,color:#000
    style NAT fill:#3b48cc,color:#fff
    style PubSub fill:#1a8f1a,color:#fff
    style PrivSub fill:#dd3522,color:#fff
    style VPC fill:#232f3e,color:#fff
```

---

## How NAT Gateway Works (Step by Step)

### Complete Traffic Flow

```mermaid
sequenceDiagram
    participant DB as 🗄️ DB Server<br/>(10.0.2.50)
    participant PrivRT as 📋 Private Route Table
    participant NAT as 🔄 NAT Gateway<br/>(EIP: 15.206.x.x)
    participant PubRT as 📋 Public Route Table
    participant IGW as 🚪 Internet Gateway
    participant Apt as 📦 apt.ubuntu.com

    Note over DB,Apt: ═══ OUTBOUND: Private Instance → Internet ═══

    DB->>PrivRT: ① Packet: src=10.0.2.50, dst=apt.ubuntu.com
    Note over PrivRT: ② Route lookup:<br/>0.0.0.0/0 → NAT Gateway
    PrivRT->>NAT: ③ Forward to NAT Gateway

    Note over NAT: ④ SNAT (Source NAT):<br/>Replace source IP<br/>10.0.2.50 → 15.206.x.x (EIP)<br/>Store in connection tracking table

    NAT->>PubRT: ⑤ Packet: src=15.206.x.x, dst=apt.ubuntu.com
    Note over PubRT: ⑥ Route lookup:<br/>0.0.0.0/0 → IGW
    PubRT->>IGW: ⑦ Forward to IGW
    IGW->>Apt: ⑧ Packet reaches internet

    Note over DB,Apt: ═══ RETURN: Internet → Private Instance ═══

    Apt->>IGW: ⑨ Response: src=apt.ubuntu.com, dst=15.206.x.x
    IGW->>NAT: ⑩ Routes to NAT (EIP owner)

    Note over NAT: ⑪ DNAT (Destination NAT):<br/>Lookup connection table<br/>Replace dest IP<br/>15.206.x.x → 10.0.2.50

    NAT->>PrivRT: ⑫ Packet: src=apt.ubuntu.com, dst=10.0.2.50
    PrivRT->>DB: ⑬ Delivered to DB Server

    Note over DB,Apt: ═══ ❌ BLOCKED: Internet → Private Instance ═══
    Apt--xDB: ❌ Cannot initiate inbound connection!
```

### SNAT vs DNAT Explained

```mermaid
graph LR
    subgraph SNAT["SNAT (Source NAT) - Outbound"]
        S1["Original: src=10.0.2.50"] -->|"NAT translates"| S2["Translated: src=15.206.x.x"]
    end

    subgraph DNAT["DNAT (Destination NAT) - Return"]
        D1["Original: dst=15.206.x.x"] -->|"NAT translates"| D2["Translated: dst=10.0.2.50"]
    end

    style SNAT fill:#e3f2fd
    style DNAT fill:#fce4ec
```

---

## Real-World Example: How a Private Server Downloads Software

This is the most common question: **"If my server is in a private subnet with no public IP, how can it run `apt-get update` or `pip install`?"**

The answer: **Through the NAT Gateway.** Let's trace the full journey.

### Scenario: Database Server Needs Security Patches

Your database server (`10.0.2.50`) is in a private subnet. It needs to run `sudo apt-get update && sudo apt-get upgrade` to install critical security patches.

```mermaid
sequenceDiagram
    participant Admin as 👨‍💻 Admin<br/>(via Bastion/SSM)
    participant DB as 🗄️ DB Server<br/>Private Subnet<br/>(10.0.2.50)<br/>❌ No Public IP
    participant PrivRT as 📋 Private Route Table
    participant NAT as 🔄 NAT Gateway<br/>Public Subnet<br/>(EIP: 15.206.x.x)
    participant PubRT as 📋 Public Route Table
    participant IGW as 🚪 Internet Gateway
    participant Apt as 📦 archive.ubuntu.com

    Admin->>DB: ssh → run: sudo apt-get update

    Note over DB: DNS resolves archive.ubuntu.com<br/>to 91.189.91.39

    rect rgb(230, 245, 255)
    Note over DB,Apt: OUTBOUND JOURNEY (Private → Internet)
    DB->>PrivRT: ① Packet: src=10.0.2.50 dst=91.189.91.39
    Note over PrivRT: ② Route lookup:<br/>91.189.91.39 not in 10.0.0.0/16<br/>→ 0.0.0.0/0 → nat-gw-xxx
    PrivRT->>NAT: ③ Forward to NAT Gateway
    Note over NAT: ④ Source NAT translation:<br/>src: 10.0.2.50 → 15.206.x.x<br/>Save mapping in connection table:<br/>{10.0.2.50:43210 ↔ 15.206.x.x:43210}
    NAT->>PubRT: ⑤ Packet: src=15.206.x.x dst=91.189.91.39
    Note over PubRT: ⑥ Route: 0.0.0.0/0 → IGW
    PubRT->>IGW: ⑦ Forward to IGW
    Note over IGW: ⑧ 1:1 NAT for NAT GW's ENI
    IGW->>Apt: ⑨ Packet reaches Ubuntu servers
    end

    rect rgb(255, 240, 230)
    Note over DB,Apt: RETURN JOURNEY (Internet → Private)
    Apt->>IGW: ⑩ Response: src=91.189.91.39 dst=15.206.x.x
    IGW->>NAT: ⑪ Deliver to NAT GW (EIP owner)
    Note over NAT: ⑫ Reverse lookup connection table:<br/>{15.206.x.x:43210 → 10.0.2.50:43210}<br/>dst: 15.206.x.x → 10.0.2.50
    NAT->>PrivRT: ⑬ Packet: src=91.189.91.39 dst=10.0.2.50
    PrivRT->>DB: ⑭ Delivered! Package list received ✅
    end

    Note over DB: apt-get update succeeded!<br/>Now runs apt-get upgrade...
```

### The Key Insight: 4 IP Translations in One Request

A single `apt-get update` packet goes through **4 address translations**:

```mermaid
graph LR
    subgraph Step1["① DB Server sends"]
        A1["src: 10.0.2.50\ndst: 91.189.91.39"]
    end
    subgraph Step2["④ NAT Gateway translates"]
        A2["src: 15.206.x.x\ndst: 91.189.91.39"]
    end
    subgraph Step3["⑩ Ubuntu responds"]
        A3["src: 91.189.91.39\ndst: 15.206.x.x"]
    end
    subgraph Step4["⑫ NAT Gateway reverse translates"]
        A4["src: 91.189.91.39\ndst: 10.0.2.50"]
    end

    A1 -->|"SNAT"| A2
    A2 -->|"Internet"| A3
    A3 -->|"DNAT"| A4

    style Step1 fill:#dd3522,color:#fff
    style Step2 fill:#3b48cc,color:#fff
    style Step3 fill:#1a8f1a,color:#fff
    style Step4 fill:#dd3522,color:#fff
```

> **The internet (Ubuntu servers) never sees `10.0.2.50`.** It only communicates with `15.206.x.x` (the NAT Gateway's Elastic IP). This is why private instances are protected — they are invisible to the internet.

### What Commands Work Through NAT Gateway?

| Command | What It Does | Works via NAT? |
|---------|-------------|----------------|
| `apt-get update` | Downloads package lists from Ubuntu repos | ✅ Yes |
| `apt-get install nginx` | Downloads & installs nginx package | ✅ Yes |
| `yum update` | Updates packages on Amazon Linux/CentOS | ✅ Yes |
| `pip install boto3` | Installs Python packages from PyPI | ✅ Yes |
| `npm install express` | Installs Node.js packages from npm | ✅ Yes |
| `curl https://api.example.com` | Makes HTTP request to external API | ✅ Yes |
| `docker pull nginx` | Pulls container image from Docker Hub | ✅ Yes |
| `git clone https://...` | Clones a repository from GitHub/GitLab | ✅ Yes |
| `wget https://...` | Downloads files from the internet | ✅ Yes |
| Someone SSH into DB | Inbound connection from internet | ❌ **BLOCKED** |
| Port scan from internet | Scanning private instance ports | ❌ **BLOCKED** |

### What If There Is No NAT Gateway?

```mermaid
graph TB
    subgraph Without_NAT["❌ Private Subnet WITHOUT NAT Gateway"]
        DB2["🗄️ DB Server\n10.0.2.50"]
        PrivRT2["📋 Private Route Table\n10.0.0.0/16 → local\n(no other routes!)"]
    end

    DB2 -->|"apt-get update\nsrc=10.0.2.50\ndst=91.189.91.39"| PrivRT2
    PrivRT2 -->|"❌ No matching route!\n91.189.91.39 not in 10.0.0.0/16\nPacket DROPPED"| Nowhere["🕳️ Packet dropped\nConnection timed out"]

    DB2 -.-|"❌ Cannot resolve DNS"| DNS2["DNS"]
    DB2 -.-|"❌ Cannot download anything"| Internet2["Internet"]

    style Without_NAT fill:#ffebee
    style Nowhere fill:#dd3522,color:#fff
```

Without a NAT Gateway (and no other internet path):
- `apt-get update` → **hangs, then timeout** (no route for the packet)
- `pip install` → **fails** with connection error
- `curl` → **fails** with "Could not resolve host" or connection timeout
- The instance is **completely isolated** from the internet
- It can still talk to other instances in the VPC via the `local` route

---

## The Complete Network Path — Everything Connected

Here's how IGW and NAT Gateway work **together** to serve both public and private subnets:

```mermaid
graph TB
    Internet["🌐 Internet\n(Package repos, APIs, etc.)"]
    IGW["🚪 Internet Gateway\nFREE | Bidirectional | 1:1 NAT"]

    subgraph VPC["🏗️ VPC (10.0.0.0/16)"]
        subgraph Public["🟢 Public Subnet (10.0.1.0/24)"]
            WebServer["💻 Web Server\n10.0.1.5 / 3.110.x.x"]
            NAT["🔄 NAT Gateway\nEIP: 15.206.x.x"]
        end

        subgraph Private["🔴 Private Subnet (10.0.2.0/24)"]
            AppServer["⚙️ App Server\n10.0.2.100"]
            DBServer["🗄️ DB Server\n10.0.2.50"]
        end

        PubRT["📋 Public RT\n10.0.0.0/16 → local\n0.0.0.0/0 → IGW"]
        PrivRT["📋 Private RT\n10.0.0.0/16 → local\n0.0.0.0/0 → NAT GW"]
    end

    Internet <-->|"Users access website"| IGW
    IGW <--> PubRT
    PubRT --> WebServer
    PubRT --> NAT

    AppServer -->|"pip install / API calls"| PrivRT
    DBServer -->|"apt-get update"| PrivRT
    PrivRT -->|"Outbound via NAT"| NAT
    NAT -->|"Then via IGW"| IGW

    Internet --x|"❌ Cannot reach\nprivate instances"| Private

    style IGW fill:#ff9900,color:#000
    style NAT fill:#3b48cc,color:#fff
    style Public fill:#1a8f1a,color:#fff
    style Private fill:#dd3522,color:#fff
    style VPC fill:#232f3e,color:#fff
```

**Summary of the path for a private instance to download software:**

```
Private Instance → Private Route Table → NAT Gateway → Public Route Table → IGW → Internet
     (10.0.2.50)    (0.0.0.0/0→NAT)     (SNAT to EIP)   (0.0.0.0/0→IGW)   (to world)
```

---

## NAT Gateway vs NAT Instance

| Feature | NAT Gateway | NAT Instance |
|---------|------------|--------------|
| **Managed by** | AWS (fully managed) | You (self-managed EC2) |
| **Availability** | HA within an AZ | Single instance (SPOF) |
| **Bandwidth** | 5-100 Gbps (auto-scales) | Depends on instance type |
| **Cost** | ~$0.045/hr + $0.045/GB | Instance cost only |
| **Maintenance** | None | Patching, monitoring, etc. |
| **Security Group** | Cannot associate | Can associate |
| **Use as bastion** | No | Yes |
| **Recommendation** | ✅ **Use this** | Legacy (avoid) |

---

## Elastic IP (EIP) — Why NAT Needs It

```mermaid
graph TD
    subgraph EIP_Explained["Elastic IP (EIP)"]
        A["What: Static public IPv4 address"]
        B["Why NAT needs it: NAT must have a<br/>consistent public IP for return traffic"]
        C["Cost: FREE when attached & in use<br/>$0.005/hr when NOT attached"]
        D["Limit: 5 per region (can request more)"]
    end

    EIP["EIP: 15.206.x.x"] -->|"Attached to"| NAT2["NAT Gateway"]
    NAT2 -->|"All outbound traffic<br/>uses this IP"| Internet2["Internet sees 15.206.x.x"]

    style EIP_Explained fill:#fff3e0
    style EIP fill:#ff9900,color:#000
```

---

## Key Rule: NAT Gateway Goes in PUBLIC Subnet

This is the most common mistake. The NAT Gateway MUST be in a **public subnet** because:

```mermaid
graph TD
    Q["Why must NAT be in PUBLIC subnet?"]
    Q --> A["NAT needs to reach the internet"]
    Q --> B["Public subnet has route to IGW"]
    Q --> C["NAT forwards traffic through IGW"]

    A --> R["NAT → Public Subnet Route Table → IGW → Internet"]

    Wrong["❌ WRONG: NAT in private subnet"]
    Wrong --> W1["Private subnet has no IGW route"]
    Wrong --> W2["NAT can't reach the internet"]
    Wrong --> W3["Nothing works!"]

    style Q fill:#ff9900,color:#000
    style Wrong fill:#dd3522,color:#fff
```

---

## NAT Gateway Properties

| Property | Detail |
|----------|--------|
| **Cost** | **~$0.045/hr** (~$33/month) + **$0.045/GB** data processed |
| **Requires** | Elastic IP + placement in a **public** subnet |
| **Direction** | **Outbound only** (no inbound initiation) |
| **Bandwidth** | 5 Gbps, auto-scales to 100 Gbps |
| **Connections** | 55,000 simultaneous per destination |
| **Protocols** | TCP, UDP, ICMP |
| **Availability** | AZ-scoped — deploy one per AZ for HA |
| **IPv6** | Not needed (use Egress-Only IGW instead) |

### Cost Example

```
Monthly cost (NAT Gateway):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Hourly:     $0.045 × 730 hrs = $32.85
Data (50GB): $0.045 × 50 GB  = $2.25
EIP:         FREE (attached)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total:                        ≈ $35.10/month
```

---

## High Availability Setup

If an AZ goes down, its NAT Gateway goes down too. Deploy one per AZ:

```mermaid
graph TB
    Internet["🌐 Internet"]
    IGW["🚪 IGW"]

    subgraph VPC["VPC"]
        subgraph AZ_A["AZ-A"]
            PubA["Public Subnet A"]
            NAT_A["🔄 NAT GW A + EIP A"]
            PrivA["Private Subnet A"]
        end

        subgraph AZ_B["AZ-B"]
            PubB["Public Subnet B"]
            NAT_B["🔄 NAT GW B + EIP B"]
            PrivB["Private Subnet B"]
        end

        PrivRTA["Private RT-A<br/>0.0.0.0/0 → NAT A"]
        PrivRTB["Private RT-B<br/>0.0.0.0/0 → NAT B"]
    end

    Internet <--> IGW
    IGW --> PubA & PubB
    PubA --> NAT_A
    PubB --> NAT_B
    PrivA -->|"Same AZ = no cross-AZ cost"| PrivRTA --> NAT_A
    PrivB -->|"Same AZ = no cross-AZ cost"| PrivRTB --> NAT_B

    style NAT_A fill:#3b48cc,color:#fff
    style NAT_B fill:#3b48cc,color:#fff
    style IGW fill:#ff9900,color:#000
```

> **Cost tip:** Cross-AZ data transfer costs $0.01/GB. Keeping NAT in the same AZ as private subnets avoids this.

---

## IGW vs NAT Gateway Comparison

```mermaid
graph LR
    subgraph IGW_Box["🚪 Internet Gateway"]
        I1["Direction: ↕️ Bidirectional"]
        I2["Cost: 💚 FREE"]
        I3["Used by: Public subnets"]
        I4["NAT type: 1:1 (Public↔Private)"]
        I5["Limit: 1 per VPC"]
    end

    subgraph NAT_Box["🔄 NAT Gateway"]
        N1["Direction: ⬆️ Outbound only"]
        N2["Cost: 💰 ~$35/month"]
        N3["Used by: Private subnets"]
        N4["NAT type: Many:1 (PAT)"]
        N5["Limit: Per AZ recommended"]
    end

    style IGW_Box fill:#ff9900,color:#000
    style NAT_Box fill:#3b48cc,color:#fff
```

### When to Use What?

```mermaid
flowchart TD
    A["Does the resource need to<br/>be reached FROM the internet?"]
    A -->|"Yes"| B["✅ Public Subnet + IGW"]
    A -->|"No"| C{"Does it need outbound<br/>internet access?"}
    C -->|"Yes"| D["✅ Private Subnet + NAT GW"]
    C -->|"No"| E["✅ Private Subnet<br/>(fully isolated)"]

    B --> F["Web servers, ALBs,<br/>Bastion hosts"]
    D --> G["DB needing updates,<br/>App calling APIs"]
    E --> H["Sensitive databases,<br/>Compliance workloads"]

    style B fill:#1a8f1a,color:#fff
    style D fill:#3b48cc,color:#fff
    style E fill:#dd3522,color:#fff
```

---

## Module Dependencies

```mermaid
graph TD
    VPC["modules/vpc"] -->|"vpc_id"| Subnet["modules/subnet"]
    VPC -->|"vpc_id"| IGW["modules/igw"]
    VPC -->|"vpc_id"| RT["modules/route-table"]
    IGW -->|"igw_id"| RT
    Subnet -->|"public_subnet_id"| NAT["modules/nat"]
    Subnet -->|"public_subnet_id<br/>private_subnet_id"| RT
    NAT -->|"nat_gw_id"| RT

    style VPC fill:#ff9900,color:#000
    style NAT fill:#3b48cc,color:#fff
    style IGW fill:#1a8f1a,color:#fff
```

---

## File Structure

```
05-nat-gateway/
├── README.md                    ← You are here
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── subnet/
│   │   ├── main.tf
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
│   └── route-table/
│       ├── main.tf              ← Public RT + Private RT + Associations
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

> **Warning:** NAT Gateway costs ~$0.045/hr. Remember to `terraform destroy` when done testing!

---

## What's Next?

➡️ [06-security-groups](../06-security-groups/) — Control inbound and outbound traffic to your resources with Security Groups.
