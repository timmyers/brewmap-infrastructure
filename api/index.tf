data "aws_route53_zone" "brewmap-co" {
  name = "brewmap.co"
}

resource "aws_route53_record" "record" {
  zone_id = "${data.aws_route53_zone.brewmap-co.zone_id}"
  name    = "api.${data.aws_route53_zone.brewmap-co.name}"
  type    = "CNAME"
  ttl     = "5"

  records = ["brewmap.nanoapp.io"]
}
