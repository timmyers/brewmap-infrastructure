resource "aws_route53_zone" "brewmap-co" {
  name = "brewmap.co"
}

resource "aws_route53_zone" "brewedhere-co" {
  name = "brewedhere.co"
}

resource "aws_s3_bucket" "s3" {
  bucket = "www.brewmap.co"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement":[
    {
      "Sid":"AllowPublicRead",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::www.brewmap.co/*"]
    }
  ]
}
POLICY
}

data "aws_acm_certificate" "wildcard" {
  domain   = "*.brewmap.co"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "brewedhere" {
  domain   = "*.brewedhere.co"
  statuses = ["ISSUED"]
}

resource "aws_cloudfront_distribution" "www" {
  origin {
    domain_name = "${aws_s3_bucket.s3.bucket_domain_name}"
    origin_id   = "S3-www.brewedhere.co"
  }

  enabled             = true
  comment             = "brewedhere static site"
  default_root_object = "index.html"

  aliases = ["www.brewedhere.co"]

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    compress         = true
    target_origin_id = "S3-www.brewedhere.co"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    error_code         = "404"
    response_code      = "200"
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${data.aws_acm_certificate.wildcard.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}

resource "aws_route53_record" "record" {
  zone_id = "${aws_route53_zone.brewedhere-co.zone_id}"
  name    = "www.${aws_route53_zone.brewedhere-co.name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.www.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.www.hosted_zone_id}"
    evaluate_target_health = false
  }
}
