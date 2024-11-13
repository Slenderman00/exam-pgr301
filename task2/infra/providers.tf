terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket = "pgr301-2024-terraform-state"
    key    = "63/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
    default_tags {
        tags = {
        Project     = "${var.prefix}-image-generator"
        Environment = var.environment
        Terraform   = "true"
        }
    }
}
