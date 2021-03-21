variable "region" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "key_arn" {
  type = string
  default = ""
}

variable "policy_file" {
  type = string
}

variable "ia_days" {
  type = number
  default = 10
}

variable "glacier_days" {
  type = number
  default = 20
}

provider "aws" {
  region = var.region
}

resource "aws_kms_key" "kms_key" {
  description             = "SSE-KMS Key"
  count = var.key_arn == "" ? 1 : 0
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.key_arn != "" ? var.key_arn : aws_kms_key.kms_key[0].arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    id = "transition"
    enabled = true
    transition {
      days          = var.ia_days
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = var.glacier_days
      storage_class = "GLACIER"
    }
  }

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = templatefile(var.policy_file, {
    bucket_arn = aws_s3_bucket.bucket.arn
  })
}