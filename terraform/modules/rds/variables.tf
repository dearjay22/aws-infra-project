variable "vpc_security_group_ids" {
  type = list(string)
}

variable "db_name" {
  type = string
  default = ""
}

variable "db_username" {
  type = string
  default = ""
}

variable "db_password" {
  type = string
  default = ""
}

variable "db_instance_class" {
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}
