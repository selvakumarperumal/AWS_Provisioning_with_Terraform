output "instance_public_ip" {
  value = aws_instance.ec2_instance.public_ip
  description = "Public IP address of the EC2 instance"
  
}