# DB Subnet Group — requires subnets in 2+ AZs
resource "aws_db_subnet_group" "main" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = { Name = "rds-subnet-group" }
}

# RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  identifier             = var.db_identifier
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_storage
  storage_type           = "gp3"

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  multi_az               = var.multi_az
  publicly_accessible    = false          # NEVER true for production!
  skip_final_snapshot    = true           # Set false in production

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"

  tags = { Name = var.db_identifier }
}
