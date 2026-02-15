output "sns_topic_arn" {
  description = "SNS topic ARN for alarm notifications"
  value       = aws_sns_topic.alarms.arn
}

output "cpu_high_alarm_arn" {
  description = "CPU high alarm ARN"
  value       = length(aws_cloudwatch_metric_alarm.cpu_high) > 0 ? aws_cloudwatch_metric_alarm.cpu_high[0].arn : null
}

output "dashboard_name" {
  description = "CloudWatch dashboard name"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.app.name
}

output "log_group_arn" {
  description = "CloudWatch log group ARN"
  value       = aws_cloudwatch_log_group.app.arn
}
