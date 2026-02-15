# EC2 Instances — one per AZ
resource "aws_instance" "web" {
  count                  = length(var.subnet_ids)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = [var.ec2_sg_id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
    echo "<h1>Server ${count.index + 1} — $(hostname)</h1>" > /var/www/html/index.html
  EOF

  tags = { Name = "web-server-${count.index + 1}" }
}

# Register instances with Target Group
resource "aws_lb_target_group_attachment" "web" {
  count            = length(var.subnet_ids)
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}
