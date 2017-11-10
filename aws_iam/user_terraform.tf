resource "aws_iam_user_policy" "terraform" {
  name = "user-terraform-policy"
  user = "terraform"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:PutUserPolicy",
        "iam:GetUserPolicy"
      ],
      "Resource": [
        "arn:aws:iam::420538485983:user/terraform"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::terraform.brewmap.co",
        "arn:aws:s3:::terraform.brewmap.co/*",
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:*",
        "acm:*",
        "cloudfront:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
