# --- CloudFront ---

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${var.name}"
}

resource "aws_cloudfront_distribution" "cf" {
  enabled             = "true"
  is_ipv6_enabled     = "${var.ipv6_enabled}"
  comment             = "${var.comment}"
  default_root_object = "index.html"
  price_class         = "${var.price_class}"


  aliases = ["${var.domains}"]

  origin {
    domain_name = "${var.bucket_domain_name}"
    origin_id   = "${var.bucket_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${var.certificate_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  default_cache_behavior {
    allowed_methods  = "${var.allowed_methods}"
    cached_methods   = "${var.cached_methods}"
    target_origin_id = "${var.bucket_name}"
    compress         = "${var.compress}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "${var.viewer_protocol_policy}"
    min_ttl                = "${var.min_ttl}"
    default_ttl            = "${var.default_ttl}"
    max_ttl                = "${var.max_ttl}"
  }

  "restrictions" {
    "geo_restriction" {
      restriction_type = "none"
    }
  } 

  tags = "${merge("${var.tags}", map("Name", format("%s", var.name)))}"
}
