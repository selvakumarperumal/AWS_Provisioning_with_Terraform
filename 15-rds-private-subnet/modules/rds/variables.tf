variable "private_subnet_ids" { type = list(string) }
variable "rds_sg_id" { type = string }

variable "db_identifier" {
  type    = string
  default = "myapp-database"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "myappdb"
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "multi_az" {
  type    = bool
  default = false
}
