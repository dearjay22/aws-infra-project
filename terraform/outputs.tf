output "s3_buckets" {
  description = "S3 bucket names"
  value       = module.s3.bucket_names
}

output "ec2_public_ip" {
  description = "EC2 public IP"
  value       = module.ec2.public_ip
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.endpoint
}
