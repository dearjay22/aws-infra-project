variable "vpc_id" {}
variable "public_subnet_id" {}
variable "instance_type" {
  type = string
}
variable "ami_name_filter" {
  description = "AMI name filter to select latest AMI"
  type        = string
}
