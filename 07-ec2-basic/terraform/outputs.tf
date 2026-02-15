output "instance_public_ip" {
  description = "Public IP of the web server"
  value       = module.ec2.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the web server"
  value       = module.ec2.private_ip
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh -i <your-private-key> ubuntu@${module.ec2.public_ip}"
}

output "web_url" {
  description = "URL to access the web server"
  value       = "http://${module.ec2.public_ip}"
}
