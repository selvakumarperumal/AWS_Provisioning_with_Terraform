# --- SNS Topic for Alarms ---
resource "aws_sns_topic" "alarms" {
  name = "${var.project_name}-alarms"
  tags = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# --- CloudWatch Log Group ---
resource "aws_cloudwatch_log_group" "app" {
  name              = "/app/${var.project_name}"
  retention_in_days = 14
  tags              = var.tags
}

# --- Metric Filter: Count ERRORs in logs ---
resource "aws_cloudwatch_log_metric_filter" "error_count" {
  name           = "${var.project_name}-error-count"
  log_group_name = aws_cloudwatch_log_group.app.name
  pattern        = "ERROR"

  metric_transformation {
    name      = "ErrorCount"
    namespace = "Custom/${var.project_name}"
    value     = "1"
  }
}

# --- CPU High Alarm ---
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count = var.instance_id != "" ? 1 : 0

  alarm_name          = "${var.project_name}-cpu-high"
  alarm_description   = "CPU utilization > ${var.cpu_threshold_high}%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.period
  statistic           = "Average"
  threshold           = var.cpu_threshold_high

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = [aws_sns_topic.alarms.arn]
  ok_actions    = [aws_sns_topic.alarms.arn]

  tags = var.tags
}

# --- CPU Low Alarm ---
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  count = var.instance_id != "" ? 1 : 0

  alarm_name          = "${var.project_name}-cpu-low"
  alarm_description   = "CPU utilization < ${var.cpu_threshold_low}%"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.period
  statistic           = "Average"
  threshold           = var.cpu_threshold_low

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = [aws_sns_topic.alarms.arn]

  tags = var.tags
}

# --- Status Check Alarm ---
resource "aws_cloudwatch_metric_alarm" "status_check" {
  count = var.instance_id != "" ? 1 : 0

  alarm_name          = "${var.project_name}-status-check-failed"
  alarm_description   = "EC2 instance status check failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = [aws_sns_topic.alarms.arn]

  tags = var.tags
}

# --- Error Count Alarm (from log metric filter)---
resource "aws_cloudwatch_metric_alarm" "error_rate" {
  alarm_name          = "${var.project_name}-error-rate"
  alarm_description   = "Application error count > 10 in 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ErrorCount"
  namespace           = "Custom/${var.project_name}"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.alarms.arn]

  tags = var.tags
}

# --- CloudWatch Dashboard ---
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = concat(
      # EC2 widgets (if instance_id provided)
      var.instance_id != "" ? [
        {
          type   = "metric"
          x      = 0
          y      = 0
          width  = 12
          height = 6
          properties = {
            title   = "EC2 CPU Utilization"
            metrics = [["AWS/EC2", "CPUUtilization", "InstanceId", var.instance_id]]
            period  = 300
            stat    = "Average"
            region  = var.aws_region
            view    = "timeSeries"
          }
        },
        {
          type   = "metric"
          x      = 12
          y      = 0
          width  = 12
          height = 6
          properties = {
            title   = "EC2 Network In/Out"
            metrics = [
              ["AWS/EC2", "NetworkIn", "InstanceId", var.instance_id],
              ["AWS/EC2", "NetworkOut", "InstanceId", var.instance_id],
            ]
            period = 300
            stat   = "Sum"
            region = var.aws_region
            view   = "timeSeries"
          }
        }
      ] : [],
      # Custom error metric widget (always shown)
      [
        {
          type   = "metric"
          x      = 0
          y      = 6
          width  = 12
          height = 6
          properties = {
            title   = "Application Errors"
            metrics = [["Custom/${var.project_name}", "ErrorCount"]]
            period  = 300
            stat    = "Sum"
            region  = var.aws_region
            view    = "timeSeries"
          }
        }
      ]
    )
  })
}
