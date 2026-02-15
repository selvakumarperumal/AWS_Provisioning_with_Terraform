output "instance_public_ip" {
  description = "Public IP of the web server"
  value       = module.ec2.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the web server"
  value       = module.ec2.private_ip
}

output "nat_gateway_eip" {
  description = "NAT Gateway Elastic IP"
  value       = module.nat.nat_eip
}

output "ssh_command" {
  description = "SSH command"
  value       = "ssh -i <private-key> ubuntu@${module.ec2.public_ip}"
}

output "web_url" {
  description = "Web server URL"
  value       = "http://${module.ec2.public_ip}"
}
