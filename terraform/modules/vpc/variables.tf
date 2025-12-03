variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr_1" {
  type = string
  description = "CIDR block for the first public subnet"
}

variable "public_subnet_cidr_2" {
  type = string
  description = "CIDR block for the second public subnet"
}