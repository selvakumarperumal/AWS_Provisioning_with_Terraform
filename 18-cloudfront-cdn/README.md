# Project 18: CloudFront CDN

## Concepts Covered

- CloudFront distributions
- Origins (S3, ALB, custom)
- Origin Access Control (OAC)
- Cache behaviors and TTLs
- HTTPS with default CloudFront certificate
- Geo-restrictions
- Price classes

---

## Architecture

```mermaid
graph TB
    User["👤 User"]

    subgraph EdgeLocations["CloudFront Edge Locations"]
        CF["CloudFront<br/>Distribution"]
        Cache["Edge Cache"]
    end

    subgraph AWS["AWS Region"]
        subgraph Origin["Origin"]
            S3["S3 Bucket<br/>(Private)"]
        end
        OAC["Origin Access<br/>Control (OAC)"]
    end

    User -->|"HTTPS"| CF
    CF -->|"Cache HIT"| Cache
    Cache -->|"Return cached"| User
    CF -->|"Cache MISS"| S3
    OAC -.->|"Authorizes CF"| S3
    S3 -->|"Response"| CF
    CF -->|"Cache + Return"| User

    style CF fill:#ff9900,color:#000
    style Cache fill:#3b48cc,color:#fff
    style S3 fill:#3b48cc,color:#fff
    style OAC fill:#dd3522,color:#fff
```

---

## CloudFront Request Flow

```mermaid
sequenceDiagram
    participant User as User (Sydney)
    participant Edge as CF Edge (Sydney)
    participant Origin as S3 Origin (Mumbai)

    User->>Edge: GET /index.html
    
    alt Cache HIT
        Edge-->>User: 200 OK (from cache)<br/>X-Cache: Hit from cloudfront
    else Cache MISS
        Edge->>Origin: GET /index.html (via OAC)
        Origin-->>Edge: 200 OK + object
        Edge->>Edge: Store in cache (TTL)
        Edge-->>User: 200 OK<br/>X-Cache: Miss from cloudfront
    end

    Note over Edge: Subsequent requests<br/>served from cache
```

---

## Key Concepts

### Origin Access Control (OAC) vs Origin Access Identity (OAI)

| Feature | OAC (Recommended) | OAI (Legacy) |
|---------|--------------------|--------------|
| S3 server-side encryption | SSE-S3, SSE-KMS | SSE-S3 only |
| POST/PUT support | Yes | No |
| All S3 regions | Yes | Some regions |
| Granular permissions | Yes | Limited |
| AWS recommends | Yes | Deprecated |

### Cache Behavior Settings

| Setting | Description |
|---------|-------------|
| `viewer_protocol_policy` | HTTP → HTTPS redirect, HTTPS only, or allow all |
| `allowed_methods` | GET, HEAD, OPTIONS, PUT, POST, etc. |
| `cached_methods` | Which methods to cache (GET, HEAD) |
| `default_ttl` | Default cache duration if origin doesn't set Cache-Control |
| `min_ttl` | Minimum time in cache regardless of headers |
| `max_ttl` | Maximum time in cache regardless of headers |
| `compress` | Enable Gzip/Brotli compression |

### Price Classes

| Price Class | Edge Locations | Cost |
|-------------|---------------|------|
| `PriceClass_All` | All locations worldwide | Highest |
| `PriceClass_200` | Most locations (no South America, Australia) | Medium |
| `PriceClass_100` | US, Canada, Europe only | Lowest |

---

## Resources Created

| Resource | Purpose |
|----------|---------|
| `aws_s3_bucket` | Origin bucket (private) |
| `aws_cloudfront_origin_access_control` | Secure access from CF to S3 |
| `aws_cloudfront_distribution` | CDN distribution |
| `aws_s3_bucket_policy` | Allow CloudFront OAC to read S3 |
| `aws_s3_object` | Sample website files |

---

## Outputs

| Output | Description |
|--------|-------------|
| `distribution_id` | CloudFront distribution ID |
| `distribution_domain` | CloudFront domain (d1234.cloudfront.net) |
| `bucket_name` | Origin S3 bucket name |
