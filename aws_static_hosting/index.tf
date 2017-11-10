resource "aws_route53_zone" "brewmap-co" {
  name = "brewmap.co"
}

resource "aws_s3_bucket" "s3" {
  bucket = "www.brewmap.co"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "cflogs.www.brewmap.co"
  acl    = "private"
}

data "aws_acm_certificate" "wildcard" {
  domain   = "*.brewmap.co"
  statuses = ["ISSUED"]
}

resource "aws_cloudfront_distribution" "www" {
  origin {
    domain_name = "${aws_s3_bucket.s3.bucket_domain_name}"
    origin_id   = "S3-www.brewmap.co"
  }

  enabled             = true
  comment             = "brewmap static site"
  default_root_object = "index.html"

  aliases = ["www.brewmap.co"]

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    compress         = true
    target_origin_id = "S3-www.brewmap.co"

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

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.logs.bucket_domain_name}"
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
  zone_id = "${aws_route53_zone.brewmap-co.zone_id}"
  name    = "www.${aws_route53_zone.brewmap-co.name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.www.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.www.hosted_zone_id}"
    evaluate_target_health = false
  }
}
