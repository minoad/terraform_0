terraform {
  required_version = ">= 1.14.0"

  backend "local" {
    path = "state/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.7, < 3.0"
    }
  }
}
