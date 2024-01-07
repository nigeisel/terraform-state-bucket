# terraform-state-bucket
Bootstrapping Script (create S3 bucket to be used as terraform backend for other Projects)

Setup backend in projects like:
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.0.0"
    }
  }
  required_version = "~>1.6"
  backend "s3" {
    bucket  = "ng.general.terraform-states"
    key     = "states/$$$PROJECT_NAME_HERE/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}
```