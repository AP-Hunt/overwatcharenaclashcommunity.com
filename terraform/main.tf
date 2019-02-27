terraform {
    backend "s3" {
        bucket = "aws-account-217567977880-terraform-state"
        key = "overwatcharenaclashcommunity.com.tfstate"
        region = "eu-west-2"
    }
}

provider "aws" {
    region = "${var.aws_region}"
}

provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
}

module "s3" {
    source = "modules/s3/"
}

module "route53" {
    source = "modules/route53/"
}

module "acm" {
    source = "modules/acm/"
    zone_id = "${module.route53.domain_zone_id}"
}

module "cdn" {
    source           = "modules/cloudfront"
    apex_bucket_name = "${module.s3.apex_bucket_name}"
    apex_bucket_dns = "${module.s3.apex_bucket_dns}"
    www_bucket_name = "${module.s3.www_bucket_name}"
    www_bucket_dns = "${module.s3.www_bucket_dns}"
    certificate_arn = "${module.acm.certificate_arn}"
    domain_zone_id = "${module.route53.domain_zone_id}"
}

module "iam" {
    source = "modules/iam/"
    www_bucket = "${module.s3.www_bucket_arn}"
    cloudfront_distribution = "${module.cdn.distribution_arn}"
}
