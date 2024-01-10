provider "aws" {
  region = "eu-central-1"
}

locals {
  default_tags = {
    ManagedBy   = "Terraform"
    Project     = "terraform-states"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "ng-general-terraform-states"
  lifecycle {
    prevent_destroy = true
  }
  tags   = local.default_tags
}

resource "aws_s3_bucket_versioning" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id

    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Id": "RequireEncryption",
      "Statement": [
        {
          "Sid": "RequireEncryptedTransport",
          "Effect": "Deny",
          "Action": ["s3:*"],
          "Resource": ["arn:aws:s3:::${aws_s3_bucket.terraform_state.bucket}/*"],
          "Condition": {
            "Bool": {
              "aws:SecureTransport": "false"
            }
          },
          "Principal": "*"
        },
        {
          "Sid": "RequireEncryptedStorage",
          "Effect": "Deny",
          "Action": ["s3:PutObject"],
          "Resource": ["arn:aws:s3:::${aws_s3_bucket.terraform_state.bucket}/*"],
          "Condition": {
            "StringNotEquals": {
              "s3:x-amz-server-side-encryption": "AES256"
            }
          },
          "Principal": "*"
        }
      ]
    }
  )
}

