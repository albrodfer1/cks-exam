# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17.0" # Specify AWS provider version
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4" # Specify TLS provider version
    }
  }
}