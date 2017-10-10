resource "aws_key_pair" "docker_swarm" {
  key_name   = "docker_swarm"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0hJyUI6KSZbRZ3k3xy5StHJlHx5YOAumjPhhcVNZryRpBIWSXRNnMqC24OYl8a2o3r/wfF8MQGDajqh5R1zGudFIHBbYylmJcDDUUa/Lcc53fSquoDh0DnaRoMYpdo51rmvrBOSTo5DCP8aJkTL+EeKscPZhNFyYiAJFJM3fuXWVcBZPMraQ0IGS9bUyPvjkPXmD016ooR06PZUkOEeDCoNZ0EfobLl5Kd300SwrOjLVbnHRSGgxukvJd6t/zZyzSLOrxPswhCzTOiiI+srYYlz4sLO7L6KMjT8JtQr9Bj4SjW0Y4Jsm2iVvBTL5e4LgsdQMvE63YnJRr7BhZqsPjUHUJcvZ6Ej612/hIaVD+8K/6kEmNrwb/BiO8n8eCMVPQBFsfme2vGZqt9c0z5BG49u2NWmrwhj4w+H/yx67vQoRJD7XpnhFTIHY+1pN6XeZuTc3E/6ATLihadd5Ww/KbI5h7W7K2RLxc7KiG4Sb4X+T8W2OFOQecEvkibC6+cQuHkJjyFnoFes4VqhE3E5AUACcu+LDorGFX5+mb+EPXq5Mm/LUURkrS7WE5vo/3udemsdQ+DRKfCXOrudnkvAO6IRDLffWIGJ/0f0a2be5YEuT1Ek44ORe1Ojc1q713zXoXJG4GyEOWvM3ZpEvh3isWXMRi5u1IqVAyHGq5MqT8JQ== timmyers09@gmail.com"
}

resource "aws_cloudformation_stack" "docker_swarm" {
  name = "docker-for-aws-swarm"
  template_url = "https://editions-us-east-1.s3.amazonaws.com/aws/stable/Docker.tmpl"
  capabilities = ["CAPABILITY_IAM"]

  parameters {
    KeyName = "${aws_key_pair.docker_swarm.key_name}"
    InstanceType = "t2.micro"
    ManagerInstanceType = "t2.small"
    ClusterSize = 1
    ManagerSize = 1
    EnableSystemPrune = "yes"
  }
}

# data "aws_route53_zone" "closetbox" {
#   name = "closetbox.com."
# }

# resource "aws_route53_record" "swarm" {
#   zone_id = "${data.aws_route53_zone.closetbox.zone_id}"
#   name    = "swarm.${data.aws_route53_zone.closetbox.name}"
#   type    = "A"
#
#   alias {
#     name                   = "${lower(aws_cloudformation_stack.docker_swarm.outputs.DefaultDNSTarget)}"
#     zone_id                = "${aws_cloudformation_stack.docker_swarm.outputs.ELBDNSZoneID}"
#     evaluate_target_health = false
#   }
# }
#
# resource "aws_route53_record" "wildcard-swarm" {
#   zone_id = "${data.aws_route53_zone.closetbox.zone_id}"
#   name    = "*.swarm.${data.aws_route53_zone.closetbox.name}"
#   type    = "A"
#
#   alias {
#     name                   = "${lower(aws_cloudformation_stack.docker_swarm.outputs.DefaultDNSTarget)}"
#     zone_id                = "${aws_cloudformation_stack.docker_swarm.outputs.ELBDNSZoneID}"
#     evaluate_target_health = false
#   }
# }
