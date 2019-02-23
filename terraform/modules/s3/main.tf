# Apex bucket
resource "aws_s3_bucket" "overwatcharenaclashcommunity_com" {
    bucket  = "overwatcharenaclashcommunity.com"
    acl = "public-read"

    website {
        redirect_all_requests_to = "https://www.overwatcharenaclashcommunity.com/"
    }
}

# WWW bucket
resource "aws_s3_bucket" "www_overwatcharenaclashcommunity_com" {
    bucket  = "www.overwatcharenaclashcommunity.com"
    acl = "public-read"

    website {
        index_document = "index.html"
        error_document = "error.html"
    }
}

resource "aws_s3_bucket_policy" "www_overwatcharenaclashcommunity_com" {
  bucket = "${aws_s3_bucket.www_overwatcharenaclashcommunity_com.id}"
  policy = "${data.aws_iam_policy_document.www_overwatcharenaclashcommunity_com_policy_document.json}"
}

data "aws_iam_policy_document" "www_overwatcharenaclashcommunity_com_policy_document" {
    statement {
        effect = "Allow"
        actions = ["s3:GetObject"]
        resources = [
            "${aws_s3_bucket.www_overwatcharenaclashcommunity_com.arn}",
            "${aws_s3_bucket.www_overwatcharenaclashcommunity_com.arn}/*",
        ]

        principals {
            type = "AWS"
            identifiers = ["*"]
        }
    }
}