output "role_arn" {
  value = module.iam.role_arn
}

output "instance_profile" {
  value = module.iam.instance_profile_name
}

output "instance_public_ip" {
  value = module.ec2.public_ip
}

output "ssh_command" {
  value = "ssh -i <private-key> ubuntu@${module.ec2.public_ip}"
}

output "test_iam" {
  description = "SSH in, then run: aws s3 ls (should work without credentials!)"
  value       = "cat /tmp/s3-test.txt"
}
