variable "db_name" {
  default = "exampledb"
}

variable "db_user" {
  default = "admin"
}

variable "db_password" {
  default = "password"
}

variable "db_instance_class" {
  default = "db.t2.micro"
}

variable "db_allocated_storage" {
  default = 20
}

variable "db_engine" {
  default = "postgresql"
}
