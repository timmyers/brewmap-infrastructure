variable "DO_TOKEN" {}
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

provider "aws" {
  region     = "us-east-1"
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
}

terraform {
  backend "s3" {
    bucket  = "terraform.brewmap.co"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "aws_iam" {
  source = "./aws_iam"
}

module "aws_static_hosting" {
  source = "./aws_static_hosting"
}
