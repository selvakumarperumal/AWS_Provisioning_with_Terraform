#Security group
# Create a security group that allows SSH access
resource "aws_security_group" "allow_ssh" {
    vpc_id = var.vpc_id          # VPC where the security group will be created
    name   = "allow_ssh"         # Name of the security group
    description = "Allow SSH inbound traffic"

    # Inbound rule to allow SSH access from anywhere
    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Outbound rule to allow all traffic to anywhere
    egress {
        from_port = 0            # Start port
        to_port   = 0           # End port
        protocol  = "-1"        # All protocols
        cidr_blocks = ["0.0.0.0/0"]  # Allow to all destinations
    }
  
}

# Ec2 instance
resource "aws_instance" "ec2_instance" {
    ami           = var.ami_id  # Ubuntu Server 20.04 LTS AMI
    instance_type = var.instance_type               # Instance type
    subnet_id     = element(var.subnet_ids, 0) # Use the first subnet ID from the list
    vpc_security_group_ids = [aws_security_group.allow_ssh.id] # Attach the security group
    key_name = var.public_key # Key pair name for SSH access
    associate_public_ip_address = true # Associate a public IP address
    # User data script to install Apache and start the service
    user_data = <<-EOF
                #!/bin/bash
                apt-get update
                apt-get install -y apache2
                systemctl start apache2
                systemctl enable apache2
                EOF

    tags = {
        Name = "ec2-instance"
    }
  
}