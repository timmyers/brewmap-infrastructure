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

provider "digitalocean" {
  token = "${var.DO_TOKEN}"
}

resource "digitalocean_droplet" "swarm1" {
  image    = "ubuntu-17-04-x64"
  name     = "brewmap-swarm1"
  region   = "sfo1"
  size     = "512mb"
  ssh_keys = ["90:86:b5:e2:22:96:a4:0c:3e:4e:56:c8:e5:06:55:a1"]
}

# Configure DNS
resource "digitalocean_domain" "brewmap-co" {
  name       = "brewmap.co"
  ip_address = "${digitalocean_droplet.swarm1.ipv4_address}"
}

resource "digitalocean_record" "wildcard-brewmap-co" {
  domain = "${digitalocean_domain.brewmap-co.name}"
  name   = "*"
  type   = "A"
  value  = "${digitalocean_droplet.swarm1.ipv4_address}"
}

resource "digitalocean_record" "www-brewmap-co" {
  domain = "${digitalocean_domain.brewmap-co.name}"
  name   = "www"
  type   = "CNAME"
  value  = "www.brewmap.co.herokudns.com."
}

resource "digitalocean_record" "swarm-brewmap-co" {
  domain = "${digitalocean_domain.brewmap-co.name}"
  name   = "swarm"
  type   = "A"
  value  = "${digitalocean_droplet.swarm1.ipv4_address}"
}
