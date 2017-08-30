variable "DO_TOKEN" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.DO_TOKEN}"
}

# # Create a new SSH key
# resource "digitalocean_ssh_key" "terraform" {
#   name       = "Terraform"
#   public_key = "${file("~/.ssh/public_github_id_rsa.pub")}"
# }

resource "digitalocean_droplet" "swarm1" {
  image    = "ubuntu-17-04-x64"
  name     = "brewmap-swarm1"
  region   = "sfo1"
  size     = "512mb"
  ssh_keys = ["bb:61:e8:53:fb:51:82:2f:ee:ed:cf:f1:6a:fc:38:02"]
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

resource "digitalocean_record" "s1-brewmap-co" {
  domain = "${digitalocean_domain.brewmap-co.name}"
  name   = "s1"
  type   = "A"
  value  = "${digitalocean_droplet.swarm1.ipv4_address}"
}

resource "digitalocean_record" "portainer-brewmap-co" {
  domain = "${digitalocean_domain.brewmap-co.name}"
  name   = "portainer"
  type   = "A"
  value  = "${digitalocean_droplet.swarm1.ipv4_address}"
}

resource "digitalocean_record" "hyper-brewmap-co" {
  domain = "${digitalocean_domain.brewmap-co.name}"
  name   = "hyper"
  type   = "A"
  value  = "${digitalocean_droplet.swarm1.ipv4_address}"
}
