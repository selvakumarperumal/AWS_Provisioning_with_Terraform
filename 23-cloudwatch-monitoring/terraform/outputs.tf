output "sns_topic_arn" {
  description = "SNS topic ARN — confirm email subscription after deploy"
  value       = module.monitoring.sns_topic_arn
}

output "dashboard_url" {
  description = "CloudWatch dashboard URL"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${module.monitoring.dashboard_name}"
}

output "log_group" {
  description = "CloudWatch log group name"
  value       = module.monitoring.log_group_name
}
