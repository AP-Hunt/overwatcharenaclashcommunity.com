resource "aws_iam_user" "overwatcharenaclashcommunity_com_deployer" {
    name = "overwatcharenaclashcommunity_com_deployer"
}

resource "aws_iam_access_key" "overwatcharenaclashcommunity_com_deployer_access_key" {
    user = "${aws_iam_user.overwatcharenaclashcommunity_com_deployer.name}"
}

resource "aws_iam_user_policy" "overwatcharenaclashcommunity_com_deployer_policy" {
    name = "overwatcharenaclashcommunity_com_deployer_policy"
    user = "${aws_iam_user.overwatcharenaclashcommunity_com_deployer.name}"

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${var.www_bucket}",
        "${var.www_bucket}/*"
      ]
    },
    {
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Effect": "Allow",
      "Resource": [
        "${var.cloudfront_distribution}"
      ]
    }
  ]
}
EOF
}
