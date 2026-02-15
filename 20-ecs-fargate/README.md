# Project 20: ECS Fargate

## Concepts Covered

- ECS Cluster (serverless with Fargate)
- Task Definitions (container configuration)
- ECS Services (desired count, deployment)
- Fargate vs EC2 launch types
- ALB integration with ECS
- IAM roles: Task Role vs Execution Role
- CloudWatch Logs for containers
- Networking mode: awsvpc

---

## Architecture

```mermaid
graph TB
    User["👤 User"]

    subgraph VPC["VPC (10.0.0.0/16)"]
        subgraph Public["Public Subnets"]
            ALB["Application<br/>Load Balancer"]
        end

        subgraph Private["Private Subnets"]
            subgraph ECS["ECS Cluster (Fargate)"]
                Service["ECS Service<br/>Desired: 2"]
                Task1["Task 1<br/>nginx:latest"]
                Task2["Task 2<br/>nginx:latest"]
            end
        end

        ALBSG["ALB Security Group<br/>Inbound: 80"]
        ECSSG["ECS Security Group<br/>Inbound: from ALB SG"]
    end

    subgraph IAM["IAM"]
        ExecRole["Execution Role<br/>(Pull images, push logs)"]
        TaskRole["Task Role<br/>(App permissions)"]
    end

    CW["CloudWatch Logs"]

    User -->|"HTTP:80"| ALB
    ALB --> Service
    Service --> Task1 & Task2
    ExecRole -.-> Task1 & Task2
    TaskRole -.-> Task1 & Task2
    Task1 & Task2 -->|"Logs"| CW

    style ALB fill:#ff9900,color:#000
    style Service fill:#ff9900,color:#000
    style Task1 fill:#1a8f1a,color:#fff
    style Task2 fill:#1a8f1a,color:#fff
    style ExecRole fill:#dd3522,color:#fff
    style TaskRole fill:#dd3522,color:#fff
```

---

## Key Concepts

### ECS Components

```mermaid
graph LR
    Cluster["ECS Cluster"] --> Service["ECS Service"]
    Service --> TaskDef["Task Definition"]
    TaskDef --> Container["Container Definition"]
    Service --> LT["Launch Type<br/>FARGATE / EC2"]
    Service --> Desired["Desired Count: N"]
    
    style Cluster fill:#232f3e,color:#fff
    style Service fill:#ff9900,color:#000
    style TaskDef fill:#3b48cc,color:#fff
    style Container fill:#1a8f1a,color:#fff
```

### Fargate vs EC2 Launch Type

| Feature | Fargate | EC2 |
|---------|---------|-----|
| Server management | None (serverless) | You manage EC2 instances |
| Scaling | Per-task | Must scale EC2 fleet |
| Pricing | Per vCPU + memory/second | EC2 instance pricing |
| Networking | awsvpc only (each task gets ENI) | bridge, host, or awsvpc |
| GPU support | No | Yes |
| Best for | Most workloads, simplicity | GPU, large persistent workloads |

### Two IAM Roles

| Role | Purpose |
|------|---------|
| **Execution Role** | ECS agent — pull images from ECR, push logs to CloudWatch |
| **Task Role** | Your app — access S3, DynamoDB, etc. from inside the container |

### Task Definition Key Fields

| Field | Description |
|-------|-------------|
| `family` | Logical name (versioned automatically) |
| `network_mode` | `awsvpc` for Fargate |
| `requires_compatibilities` | `["FARGATE"]` |
| `cpu` | vCPU units (256 = 0.25 vCPU) |
| `memory` | MiB (512 = 0.5 GB) |
| `container_definitions` | JSON array of container configs |

---

## Resources Created

| Resource | Purpose |
|----------|---------|
| `aws_ecs_cluster` | ECS cluster |
| `aws_ecs_task_definition` | Container configuration |
| `aws_ecs_service` | Maintains desired task count |
| `aws_iam_role` (execution) | Pull images + push logs |
| `aws_iam_role` (task) | Application permissions |
| `aws_cloudwatch_log_group` | Container logs |
| `aws_lb` + target group | ALB for traffic distribution |
| VPC, Subnets, SGs | Network infrastructure |

---

## Outputs

| Output | Description |
|--------|-------------|
| `cluster_name` | ECS cluster name |
| `service_name` | ECS service name |
| `alb_dns_name` | ALB DNS to access the app |
