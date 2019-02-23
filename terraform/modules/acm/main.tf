provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
}

resource "aws_acm_certificate" "star_overwatcharenaclashcommunity_com" {
    provider = "aws.us-east-1"

    domain_name = "*.overwatcharenaclashcommunity.com"
    validation_method = "DNS"
}

resource "aws_route53_record" "star_overwatcharenaclashcommunity_com_validation_record" {
    name    = "${aws_acm_certificate.star_overwatcharenaclashcommunity_com.domain_validation_options.0.resource_record_name}"
    type    = "${aws_acm_certificate.star_overwatcharenaclashcommunity_com.domain_validation_options.0.resource_record_type}"
    zone_id = "${var.zone_id}"
    records = ["${aws_acm_certificate.star_overwatcharenaclashcommunity_com.domain_validation_options.0.resource_record_value}"]
    ttl     = 60
}

resource "aws_acm_certificate_validation" "star_overwatcharenaclashcommunity_com_validation" {
    provider = "aws.us-east-1"
    
    certificate_arn = "${aws_acm_certificate.star_overwatcharenaclashcommunity_com.arn}"
    validation_record_fqdns = ["${aws_route53_record.star_overwatcharenaclashcommunity_com_validation_record.fqdn}"]
}

