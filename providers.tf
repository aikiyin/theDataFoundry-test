terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4"
    }
  }
}

provider "aws" {
  region              = "ap-southeast-2"
  allowed_account_ids = ["721495903582"]

  default_tags {
    tags = {
      costcode       = "de"
      "service"   = "lambda"
    }
  }
}


provider "archive" {}
#test

