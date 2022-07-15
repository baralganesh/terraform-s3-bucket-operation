# AWS Provider Configure
provider "aws" {
  region = "us-east-1"  
}

#set logging bucket
locals {
  bucket_name="testing-15-07-2022"
}

#provision s3 bucket 

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket

  tags = {
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

# disable public access

resource "aws_s3_bucket_public_access_block" "block_pub_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_logging" "s3_logging" {
  bucket = aws_s3_bucket.s3_bucket.id
  target_bucket = local.bucket_name
  target_prefix = "${aws_s3_bucket.s3_bucket.id}"
}

#server side encryption

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encrypt" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}