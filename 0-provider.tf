terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.37.0"
    }
  }

  backend "s3" {
    bucket = "fiap-proj-fase4-equipe15"
    key    = "gateway"
    region = "us-east-1"
  }

}

provider "aws" {
  region = "us-east-1"
}