resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.public_key
  associate_public_ip_address = true
  subnet_id     = element(var.subnet_ids, 0)
  security_groups = [var.security_group_id]

  tags = {
    Name = "EC2-Instance"
  }
  # User data script to install Apache and start the service
user_data = <<-EOF
            #!/bin/bash
            apt-get update -y
            apt-get install -y apache2
            systemctl start apache2
            systemctl enable apache2
            echo "<h1>Hello from Terraform</h1>" > /var/www/html/index.html
            EOF
}