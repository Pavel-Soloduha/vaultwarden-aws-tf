locals {
  full_domain_name    = format("%s%s.%s", var.resource_prefix, var.domain_name_prefix, var.hosted_zone)
  configs_bucket_name = format("%s%s-configs-bucket", var.resource_prefix, var.s3_bucket_name_prefix)
  backups_bucket_name = format("%s%s-backups-bucket", var.resource_prefix, var.s3_bucket_name_prefix)
}
