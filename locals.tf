locals {
  full_domain_name    = format("%s.%s", var.domain_name_prefix, var.hosted_zone)
  configs_bucket_name = format("%s-configs-bucket", var.s3_bucket_name_prefix)
  backups_bucket_name = format("%s-backups-bucket", var.s3_bucket_name_prefix)

  asg_tags = concat([
    for key, value in var.default_tags : {
      key                 = key
      value               = value
      propagate_at_launch = true
    }
    ], [
    {
      key                 = "Name"
      value               = "vw-asg"
      propagate_at_launch = true
    }
    ]
  )
}