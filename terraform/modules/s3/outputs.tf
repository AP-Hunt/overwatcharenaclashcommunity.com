output "apex_bucket_arn" {
    value = "${aws_s3_bucket.overwatcharenaclashcommunity_com.arn}"
}

output "apex_bucket_name" {
    value = "${aws_s3_bucket.overwatcharenaclashcommunity_com.id}"
}

output "apex_bucket_dns" {
    value = "${aws_s3_bucket.overwatcharenaclashcommunity_com.bucket_regional_domain_name}"
}

output "www_bucket_arn" {
    value = "${aws_s3_bucket.www_overwatcharenaclashcommunity_com.arn}"
}

output "www_bucket_name" {
    value = "${aws_s3_bucket.www_overwatcharenaclashcommunity_com.id}"
}

output "www_bucket_dns" {
    value = "${aws_s3_bucket.www_overwatcharenaclashcommunity_com.bucket_regional_domain_name}"
}