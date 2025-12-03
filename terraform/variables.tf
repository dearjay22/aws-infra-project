variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# S3
variable "s3_bucket_names" {
  type        = list(string)
  description = "List of 4 private S3 bucket names (Terraform)"
  default     = []
}

# VPC / EC2
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  default = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  default = "10.0.2.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_name_filter" {
  description = "AMI name filter (used to find latest Amazon Linux 2)"
  type        = string
  default     = "amzn2-ami-hvm-*-x86_64-gp2"
}

# RDS
variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "RDS admin username"
  type        = string
  default     = ""
}

variable "db_password" {
  description = "RDS admin password (do NOT commit secrets to GitHub)"
  type        = string
  default     = ""
}

variable "db_allocated_storage" {
  description = "RDS allocated storage (GB)"
  type        = number
  default     = 20
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}
