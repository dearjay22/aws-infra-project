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

1. **AWS Account** with sufficient permissions:

   * CloudFormation
   * CodePipeline
   * CodeBuild
   * IAM
   * CDK deployment permissions

2. **AWS CLI** installed and configured:

   ```bash
   aws configure
   ```

3. **AWS CDK CLI** installed:

   ```bash
   npm install -g aws-cdk
   ```

4. Python 3.11 and pip installed.

---

## Terraform: Quick start (root: `terraform/`)
1. `cd terraform`

2. Edit `terraform.tfvars` and fill required variables:
   - `s3_bucket_names = ["unique-bucket-1", "unique-bucket-2", "unique-bucket-3", "unique-bucket-4"]`
   - `db_name = "mydb"`
   - `db_username = "admin"`
   - `db_password = "ReplaceWithSecurePassword!"`
   - (Optional) `aws_region`, `instance_type`

3. Initialize:
   ```
    terraform init
   ```

4. Plan:
   ```
    terraform plan -var-file="terraform.tfvars"
   ```

5. Apply:
   ```
    terraform apply -var-file="terraform.tfvars"
   ```

6. Outputs will show:
    - S3 bucket names
    - EC2 public IP
    - RDS endpoint

**Notes:**
    - State: The backend is local and the file `terraform.tfstate` will be created in this folder.
    - AMI: Terraform uses a data source to pick latest Amazon Linux 2 (no hardcoded AMI).
    - Do NOT commit `terraform.tfstate` or files with real secrets to GitHub.

## CloudFormation: Quick start (root: `cdk-app/`)

2. **Install Python dependencies**:

   ```bash
   pip install --upgrade pip
   pip install -r requirements.txt
   ```

3. **Bootstrap CDK environment** (if first time):

   ```bash
   cdk bootstrap aws://<ACCOUNT_ID>/<REGION>
   ```

4. **Deploy the pipeline**:

   ```bash
   cdk deploy InfraStack --require-approval never
   ```

5. **Pipeline Flow**:

   * **Source Stage**: Pulls code from GitHub.
   * **Build Stage**: Synthesizes CDK templates (`cdk synth`) and stores in `cdk.out`.
   * **Deploy Stage**: Deploys the `InfraStack` using CloudFormation templates from build artifacts.

  ```

## What to fill in `terraform.tfvars`
- `s3_bucket_names` — 4 globally unique names (lowercase, no spaces).
- `db_name`, `db_username`, `db_password`.
- Optionally override `instance_type` and `aws_region`.

## Security & Best Practices (notes for marking)
- Sensitive values (db_password) should be provided via tfvars or environment variables and **NOT** pushed to GitHub.
- In production, restrict security group ingress, disable public RDS access, and use remote state (S3 + locking).
- Modules are used to keep infra modular and reusable.

## Cleanup
- Terraform:
   ```
    terraform destroy -var-file="terraform.tfvars"
   ```

- CloudFormation:
   ```
    cdk destroy InfraStack --require-approval never
   ```

## Troubleshooting tips
- IAM permission errors: ensure user/role has EC2, S3, RDS, CloudFormation privileges.
- Unique bucket names: S3 bucket names must be globally unique.
- RDS password: must satisfy AWS complexity rules (8+ chars, etc).
