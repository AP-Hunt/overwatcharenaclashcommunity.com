module "cloudfront" {
  source = "vendor/"
  bucket_name = "${var.www_bucket_name}"
  bucket_domain_name = "${var.www_bucket_dns}"
  certificate_arn = "${var.certificate_arn}"
  domains = ["www.overwatcharenaclashcommunity.com", "overwatcharenaclashcommunity.com"]
  name = "www.overwatcharenaclashcommunity.com_distribution"
  viewer_protocol_policy = "redirect-to-https"
}

data "aws_s3_bucket" "apex_bucket" {
  bucket = "${var.apex_bucket_name}"
}

resource "aws_route53_record" "cloudfront_apex_record" {
  zone_id = "${var.domain_zone_id}"
  name = "overwatcharenaclashcommunity.com."
  type = "A"
  
  alias {
      name = "${data.aws_s3_bucket.apex_bucket.website_domain}"
      zone_id = "${data.aws_s3_bucket.apex_bucket.hosted_zone_id}"
      evaluate_target_health = true
  }
}

resource "aws_route53_record" "cloudfront_www_record" {
  zone_id = "${var.domain_zone_id}"
  name = "www.overwatcharenaclashcommunity.com."
  type = "A"
  
  alias {
      name = "${module.cloudfront.cf_domain_name}"
      zone_id = "${module.cloudfront.cf_hosted_zone_id}"
      evaluate_target_health = true
  }
}