output "role_arn" {
  description = "IAM role ARN"
  value       = aws_iam_role.ec2_role.arn
}

output "role_name" {
  value = aws_iam_role.ec2_role.name
}

output "instance_profile_name" {
  description = "Instance profile name (attach to EC2)"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "policy_arn" {
  value = aws_iam_policy.s3_read.arn
}
