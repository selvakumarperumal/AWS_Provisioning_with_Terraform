# Define an AWS Security Group resource to allow SSH and web access
resource "aws_security_group" "allow_ssh" {
    description = "Allow SSH and web traffic"
    vpc_id = var.vpc_id
    name = "allow_ssh_web"

    # Inbound rule for SSH
    ingress {
        description = "Allow SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Inbound rule for HTTP
    ingress {
        description = "Allow HTTP from anywhere"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Inbound rule for HTTPS
    ingress {
        description = "Allow HTTPS from anywhere"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Outbound rule to allow all traffic
    egress {
        description = "Allow all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}