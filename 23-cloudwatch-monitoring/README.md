# Project 23: CloudWatch Monitoring

## Concepts Covered

- CloudWatch Metrics and Alarms
- SNS Topics for notifications
- CloudWatch Dashboards
- Log Groups and Log Streams
- Metric Filters (extract metrics from logs)
- Composite alarms
- Alarm actions (SNS, Auto Scaling, EC2)

---

## Architecture

```mermaid
graph TB
    subgraph Monitored["Monitored Resources"]
        EC2["EC2 Instance"]
        ALB["Application LB"]
        RDS["RDS Database"]
    end

    subgraph CloudWatch["Amazon CloudWatch"]
        Metrics["Metrics<br/>CPU, Network, Disk"]
        Alarms["Alarms<br/>CPU > 80%<br/>StatusCheck Failed"]
        Dashboard["Dashboard<br/>Visual overview"]
        Logs["Log Groups<br/>/var/log/messages"]
        MF["Metric Filters<br/>ERROR count"]
    end

    subgraph Notifications["Notifications"]
        SNS["SNS Topic"]
        Email["Email<br/>Subscription"]
    end

    EC2 -->|"Push metrics"| Metrics
    ALB -->|"Push metrics"| Metrics
    RDS -->|"Push metrics"| Metrics
    Metrics --> Alarms
    Alarms -->|"ALARM state"| SNS
    SNS --> Email
    Metrics --> Dashboard
    EC2 -->|"Logs"| Logs
    Logs --> MF
    MF -->|"Custom metric"| Metrics

    style Alarms fill:#dd3522,color:#fff
    style SNS fill:#ff9900,color:#000
    style Dashboard fill:#3b48cc,color:#fff
    style Metrics fill:#232f3e,color:#fff
```

---

## Alarm State Machine

```mermaid
stateDiagram-v2
    [*] --> INSUFFICIENT_DATA: Alarm created
    INSUFFICIENT_DATA --> OK: Data arrives,<br/>below threshold
    INSUFFICIENT_DATA --> ALARM: Data arrives,<br/>above threshold
    OK --> ALARM: Threshold breached<br/>for evaluation periods
    ALARM --> OK: Metric recovers<br/>below threshold
    
    ALARM --> ALARM: Still breaching
    OK --> OK: Still healthy
    
    note right of ALARM: Triggers SNS notification
    note right of OK: Triggers OK notification (if configured)
```

---

## Key Concepts

### CloudWatch Metric Dimensions

| Service | Key Metrics | Namespace |
|---------|-------------|-----------|
| **EC2** | CPUUtilization, StatusCheckFailed, NetworkIn/Out | AWS/EC2 |
| **ALB** | RequestCount, TargetResponseTime, HTTPCode_Target_5XX | AWS/ApplicationELB |
| **RDS** | CPUUtilization, FreeStorageSpace, DatabaseConnections | AWS/RDS |
| **Lambda** | Invocations, Duration, Errors, Throttles | AWS/Lambda |
| **S3** | BucketSizeBytes, NumberOfObjects | AWS/S3 |

### Alarm Evaluation

| Setting | Description |
|---------|-------------|
| `period` | Length of each evaluation period (seconds) |
| `evaluation_periods` | How many periods to evaluate |
| `datapoints_to_alarm` | How many periods must breach (M of N) |
| `statistic` | Average, Sum, Minimum, Maximum, SampleCount |
| `comparison_operator` | GreaterThanThreshold, LessThanThreshold, etc. |
| `threshold` | The value to compare against |

**Example**: CPU > 80% for 3 out of 5 periods of 60 seconds = alarm if CPU exceeds 80% in at least 3 of the last 5 minutes.

### SNS Subscription Types

| Protocol | Endpoint | Use Case |
|----------|----------|----------|
| `email` | Email address | Notifications to team |
| `sms` | Phone number | Critical alerts |
| `lambda` | Function ARN | Automated remediation |
| `https` | Webhook URL | PagerDuty, Slack, etc. |
| `sqs` | Queue ARN | Async processing |

---

## Resources Created

| Resource | Purpose |
|----------|---------|
| `aws_sns_topic` | Notification topic |
| `aws_sns_topic_subscription` | Email subscription |
| `aws_cloudwatch_metric_alarm` | CPU high alarm |
| `aws_cloudwatch_metric_alarm` | CPU low alarm |
| `aws_cloudwatch_metric_alarm` | Status check alarm |
| `aws_cloudwatch_dashboard` | Visual dashboard |
| `aws_cloudwatch_log_group` | Application log group |
| `aws_cloudwatch_log_metric_filter` | Extract ERROR count from logs |

---

## Outputs

| Output | Description |
|--------|-------------|
| `sns_topic_arn` | SNS topic ARN for alarm notifications |
| `cpu_alarm_arn` | CPU high alarm ARN |
| `dashboard_name` | CloudWatch dashboard name |
| `log_group_name` | Log group name |
