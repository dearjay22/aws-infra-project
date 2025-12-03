resource "aws_s3_bucket" "this" {
  for_each = { for idx, name in var.bucket_names : idx => name }

  bucket = each.value

  tags = {
    Name    = each.value
    OwnedBy = "PROG8870"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each = aws_s3_bucket.this

  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}