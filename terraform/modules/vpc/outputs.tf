# modules/vpc/outputs.tf

# VPC ID
output "vpc_id" {
  value = aws_vpc.this.id
}

# Public subnet IDs (list)
output "public_subnet_ids" {
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

# DB Subnet IDs (from the subnet group)
output "db_subnet_ids" {
  value = aws_db_subnet_group.db_subnets.subnet_ids
}

# DB Security Group ID
output "db_sg_id" {
  value = aws_security_group.db_sg.id
}
