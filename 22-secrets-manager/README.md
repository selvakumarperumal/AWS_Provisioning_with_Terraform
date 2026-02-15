# Project 22: Secrets Manager

## Concepts Covered

- AWS Secrets Manager for secret storage
- Secret creation and versioning
- Automatic secret rotation
- Secret retrieval in Terraform
- KMS encryption for secrets
- Secret policies (resource-based)
- Integration with RDS, Lambda, EC2

---

## Architecture

```mermaid
graph TB
    subgraph SecretsManager["AWS Secrets Manager"]
        Secret["Secret<br/>/app/database/credentials"]
        Version["Versions<br/>AWSCURRENT / AWSPREVIOUS"]
        KMS["KMS Encryption"]
    end

    subgraph Consumers["Secret Consumers"]
        EC2["EC2 Instance<br/>(via IAM Role)"]
        Lambda["Lambda Function<br/>(env var reference)"]
        RDS["RDS<br/>(master password)"]
        App["Application Code<br/>(SDK call)"]
    end

    Secret --> Version
    KMS -.->|"Encrypts"| Secret
    EC2 -->|"GetSecretValue"| Secret
    Lambda -->|"GetSecretValue"| Secret
    Secret -.->|"Managed password"| RDS
    App -->|"AWS SDK"| Secret

    style Secret fill:#dd3522,color:#fff
    style KMS fill:#3b48cc,color:#fff
    style EC2 fill:#1a8f1a,color:#fff
    style Lambda fill:#ff9900,color:#000
```

---

## Secret Lifecycle

```mermaid
sequenceDiagram
    participant Admin as Admin/Terraform
    participant SM as Secrets Manager
    participant KMS as KMS
    participant App as Application

    Admin->>SM: CreateSecret (key-value JSON)
    SM->>KMS: Encrypt secret value
    KMS-->>SM: Encrypted blob
    SM->>SM: Store as AWSCURRENT version
    SM-->>Admin: Secret ARN

    App->>SM: GetSecretValue (by name or ARN)
    SM->>SM: Check IAM permissions
    SM->>KMS: Decrypt
    KMS-->>SM: Plaintext
    SM-->>App: Secret JSON

    Note over SM: Rotation (if configured)
    SM->>SM: Create new version
    SM->>SM: Move AWSCURRENT label
    SM->>SM: Old version → AWSPREVIOUS
```

---

## Key Concepts

### Secrets Manager vs Parameter Store

| Feature | Secrets Manager | Parameter Store (SSM) |
|---------|----------------|----------------------|
| Cost | $0.40/secret/month + API calls | Free tier (standard) |
| Automatic rotation | Built-in Lambda rotation | Manual |
| Cross-region replication | Yes | No |
| Max secret size | 64 KB | 8 KB (advanced: 8 KB) |
| Versioning | Automatic (staging labels) | Yes (basic) |
| RDS integration | Native (managed passwords) | Manual |
| Best for | Database creds, API keys | Config values, feature flags |

### Secret Naming Convention

```
/<environment>/<service>/<secret-type>
```

Examples:
- `/dev/myapp/database-credentials`
- `/prod/api/stripe-key`
- `/staging/auth/jwt-secret`

### Secret Rotation

| Rotation Type | Description |
|--------------|-------------|
| **Single-user** | Updates one set of credentials |
| **Alternating-user** | Alternates between two IAM users |
| **Lambda-based** | Custom rotation logic |
| **RDS managed** | Automatic for supported RDS engines |

---

## Resources Created

| Resource | Purpose |
|----------|---------|
| `aws_secretsmanager_secret` | The secret container |
| `aws_secretsmanager_secret_version` | The secret value |
| `aws_iam_policy` | Policy to read the secret |
| `aws_iam_role` | Role that can access the secret |
| `aws_kms_key` | Custom KMS key for encryption |
| `aws_kms_alias` | Friendly name for the KMS key |

---

## Outputs

| Output | Description |
|--------|-------------|
| `secret_arn` | ARN of the secret |
| `secret_name` | Name of the secret |
| `kms_key_arn` | KMS key ARN used for encryption |
| `reader_policy_arn` | IAM policy ARN for reading the secret |
