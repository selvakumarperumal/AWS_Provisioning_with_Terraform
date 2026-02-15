output "function_name" {
  description = "Lambda function name"
  value       = module.lambda.function_name
}

output "api_endpoint" {
  description = "API Gateway endpoint — try: curl <endpoint>/hello"
  value       = module.lambda.api_endpoint
}

output "log_group" {
  description = "CloudWatch log group"
  value       = module.lambda.log_group_name
}
