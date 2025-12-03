locals {
  # expect 4 names; user provides in terraform.tfvars
  s3_names = var.s3_bucket_names
}

# S3 module (creates 4 buckets)
module "s3" {
  source            = "./modules/s3"
  bucket_names      = local.s3_names
  enable_versioning = true
}

# VPC + networking
module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr_1 = var.public_subnet_cidr_1
  public_subnet_cidr_2 = var.public_subnet_cidr_2
}

# EC2 (uses vpc outputs)
module "ec2" {
  source           = "./modules/ec2"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
  instance_type    = var.instance_type
  ami_name_filter  = var.ami_name_filter
}

# RDS
module "rds" {
  source                 = "./modules/rds"
  vpc_security_group_ids = [module.vpc.db_sg_id]
  db_subnet_ids          = module.vpc.db_subnet_ids
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  db_instance_class      = var.db_instance_class
}
