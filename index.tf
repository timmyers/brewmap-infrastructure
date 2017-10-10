variable "DO_TOKEN" {}
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

provider "aws" {
  region     = "us-east-1"
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
}

resource "aws_iam_user_policy" "terraform" {
  name = "user-terraform-policy"
  user = "terraform"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:PutUserPolicy",
        "iam:GetUserPolicy"
      ],
      "Resource": [
        "arn:aws:iam::420538485983:user/terraform"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::terraform.brewmap.co",
        "arn:aws:s3:::terraform.brewmap.co/*"
      ]
    }
  ]
}
EOF
}

terraform {
  backend "s3" {
    bucket  = "terraform.brewmap.co"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
