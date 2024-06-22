resource "aws_iam_instance_profile" "this" {
  name = "${var.resource_prefix}ec2_instance_profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name = "${var.resource_prefix}vw_ec2_instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = merge(
    var.default_tags, {
      Name = "${var.resource_prefix}vw_ec2_instance_role"
    }
  )
}

resource "aws_iam_policy" "route53_dns" {
  name        = "${var.resource_prefix}vw_route53_dns_policy"
  description = "This policy is used to allow Certbot on EC2 instance generate short live Let's Encrypt SSL certificates"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "certbot-dns-route53 sample policy",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ListHostedZones",
          "route53:GetChange"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets"
        ],
        "Resource" : [
          format("arn:aws:route53:::hostedzone/%s", data.aws_route53_zone.this.zone_id)
        ]
      }
    ]
  })

  tags = merge(
    var.default_tags, {
      Name = "${var.resource_prefix}vw_route53_dns_policy"
    }
  )
}

resource "aws_iam_policy" "s3" {
  name        = "${var.resource_prefix}vw_s3_policy"
  description = "This policy is used to allow EC2 instance connect to S3 bucket to save backups and get configuration files"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : format("arn:aws:s3:::%s", local.configs_bucket_name)
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : format("arn:aws:s3:::%s/*", local.configs_bucket_name)
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : format("arn:aws:s3:::%s", local.backups_bucket_name)
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject"
        ],
        "Resource" : format("arn:aws:s3:::%s/*", local.backups_bucket_name)
      }
    ]
  })

  tags = merge(
    var.default_tags, {
      Name = "${var.resource_prefix}vw_s3_policy"
    }
  )
}

resource "aws_iam_role_policy_attachment" "ec2_route53_dns" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.route53_dns.arn
}

resource "aws_iam_role_policy_attachment" "ec2_s3" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.s3.arn
}
