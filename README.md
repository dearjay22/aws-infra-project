# AWS Infrastructure Automation — Terraform + CloudFormation

## Overview
This project demonstrates a multi-service AWS infra using Terraform (modular) and CloudFormation (YAML). It creates S3 buckets, VPC, EC2, and RDS.

## Structure
See folder structure in repository root.

## Prerequisites
- AWS CLI configured (`aws configure`) with credentials that have required permissions.
- Terraform v1.4+ installed.
- An EC2 Key Pair in the selected region (for SSH).
- For CloudFormation RDS, you may need subnet IDs and security group IDs or modify the rds.yaml to create them.

## Terraform: Quick start (root: `terraform/`)
1. `cd terraform`

2. Edit `terraform.tfvars` and fill required variables:
   - `s3_bucket_names = ["unique-bucket-1", "unique-bucket-2", "unique-bucket-3", "unique-bucket-4"]`
   - `db_name = "mydb"`
   - `db_username = "admin"`
   - `db_password = "ReplaceWithSecurePassword!"`
   - (Optional) `aws_region`, `instance_type`

3. Initialize:
    terraform init

4. Plan:
    terraform plan -var-file="terraform.tfvars"

5. Apply:
    terraform apply -var-file="terraform.tfvars"

6. Outputs will show:
    - S3 bucket names
    - EC2 public IP
    - RDS endpoint

**Notes:**
    - State: The backend is local and the file `terraform.tfstate` will be created in this folder.
    - AMI: Terraform uses a data source to pick latest Amazon Linux 2 (no hardcoded AMI).
    - Do NOT commit `terraform.tfstate` or files with real secrets to GitHub.

## CloudFormation: Quick start (root: `cloudformation/`)

1. S3 (deploy three buckets)
  ```
  aws cloudformation create-stack --stack-name prog8870-s3
    --template-body file://s3.yaml
    --parameters ParameterKey=BucketName1,ParameterValue=unique-bucket-1
    ParameterKey=BucketName2,ParameterValue=unique-bucket-2
    ParameterKey=BucketName3,ParameterValue=unique-bucket-3
    --capabilities CAPABILITY_NAMED_IAM
  ```
2. EC2 (deploy VPC + instance)
- Find an AMI id for Amazon Linux 2 (example shown below) or pass `AmiId` param:
  ```
  # quick AMI lookup (Linux 2) with AWS CLI (us-east-1)
  aws ec2 describe-images --owners amazon \
    --filters 'Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2' \
    --query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' --output text --region us-east-1
  ```

- Create stack (specify KeyName and AmiId):
  ```
  aws cloudformation create-stack --stack-name prog8870-ec2 \
    --template-body file://ec2.yaml \
    --parameters ParameterKey=InstanceType,ParameterValue=t3.micro \
                 ParameterKey=AmiId,ParameterValue=ami-xxxxxxxx \
                 ParameterKey=KeyName,ParameterValue=your-ec2-keypair \
    --capabilities CAPABILITY_NAMED_IAM
  ```

3. RDS
- Because `rds.yaml` expects Subnet IDs and SG IDs or modifications, either:
  - Replace placeholder values before deployment, or
  - Expand template to create the VPC/Subnets/Security groups similarly to `ec2.yaml`.

- Example CLI with parameters (if template adapted):
  ```
  aws cloudformation create-stack --stack-name prog8870-rds \
    --template-body file://rds.yaml \
    --parameters ParameterKey=DBName,ParameterValue=mydb \
                 ParameterKey=DBUser,ParameterValue=admin \
                 ParameterKey=DBPassword,ParameterValue=ChangeMe123! \
                 ParameterKey=DBInstanceClass,ParameterValue=db.t3.micro
  ```

## What to fill in `terraform.tfvars`
- `s3_bucket_names` — 4 globally unique names (lowercase, no spaces).
- `db_name`, `db_username`, `db_password`.
- Optionally override `instance_type` and `aws_region`.

## Security & Best Practices (notes for marking)
- Sensitive values (db_password) should be provided via tfvars or environment variables and **NOT** pushed to GitHub.
- In production, restrict security group ingress, disable public RDS access, and use remote state (S3 + locking).
- Modules are used to keep infra modular and reusable.

## Deliverables for submission
- GitHub repo URL (push this folder).
- Screenshots:
- S3 buckets with versioning enabled (AWS Console).
- EC2 instance with public IP.
- RDS running instance (Console).
- Terraform apply output and CloudFormation stack outputs.
- Terraform files: `main.tf`, `provider.tf`, `variables.tf`, `terraform.tfvars` (template), `backend.tf`
- CloudFormation templates: `cloudformation/s3.yaml`, `cloudformation/ec2.yaml`, `cloudformation/rds.yaml`
- README.md (this file).
- PPT slides (we'll create these after code is final).

## Cleanup
- Terraform:
    terraform destroy -var-file="terraform.tfvars"

- CloudFormation:
    aws cloudformation delete-stack --stack-name prog8870-s3
    aws cloudformation delete-stack --stack-name prog8870-ec2
    aws cloudformation delete-stack --stack-name prog8870-rds

## Troubleshooting tips
- IAM permission errors: ensure user/role has EC2, S3, RDS, CloudFormation privileges.
- Unique bucket names: S3 bucket names must be globally unique.
- RDS password: must satisfy AWS complexity rules (8+ chars, etc).