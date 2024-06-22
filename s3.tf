resource "aws_s3_bucket" "config" {
  bucket = local.configs_bucket_name

  tags = merge(
    var.default_tags, {
      Name = local.configs_bucket_name
    }
  )
}

resource "aws_s3_bucket_ownership_controls" "config_control" {
  bucket = aws_s3_bucket.config.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "config_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.config_control]
  bucket     = aws_s3_bucket.config.id
  acl        = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config_encryption" {
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
  bucket = aws_s3_bucket.config.id
}

resource "aws_s3_bucket" "backup" {
  bucket = local.backups_bucket_name

  tags = merge(
    var.default_tags, {
      Name = local.backups_bucket_name
    }
  )
}

resource "aws_s3_bucket_ownership_controls" "backup_control" {
  bucket = aws_s3_bucket.backup.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "backup_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.backup_control]

  bucket = aws_s3_bucket.backup.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup_encryption" {
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
  bucket = aws_s3_bucket.backup.id
}

resource "random_string" "admin-token" {
  length           = 48
  special          = true
  lower            = true
  numeric          = true
  upper            = true
  override_special = "-_=+/"
}

resource "aws_s3_object" "backup_script" {
  bucket = aws_s3_bucket.config.id
  key    = "backup.sh"
  content = templatefile("data/scripts/backup.sh", {
    s3_bucket_name = local.backups_bucket_name
  })
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "notifier" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "AWS_SpotTerminationNotifier.sh"
  source                 = "data/AWS_SpotTerminationNotifier.sh"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "maint-script" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "maintenance.sh"
  source                 = "data/scripts/maintenance.sh"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "docker_compose" {
  bucket = aws_s3_bucket.config.id
  key    = "docker-compose.yml"
  content = templatefile("data/docker-compose.yml", {
    admin_token = random_string.admin-token.result,
    full_url    = format("https://%s", local.full_domain_name)
  })
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "nginx_dockerfile" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "Dockerfile"
  source                 = "data/Dockerfile"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "nginx_conf" {
  bucket = aws_s3_bucket.config.id
  key    = "nginx.conf"
  content = templatefile("data/nginx.conf", {
    full_domain_name = local.full_domain_name
  })
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "update_script" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "update.sh"
  source                 = "data/scripts/update.sh"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "warden_jail" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "vaultwarden-jail.conf"
  source                 = "data/fail2ban/vaultwarden-jail.conf"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "warden_filter" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "vaultwarden-filter.conf"
  source                 = "data/fail2ban/vaultwarden-filter.conf"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "warden_admin_jail" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "vaultwarden-admin-jail.conf"
  source                 = "data/fail2ban/vaultwarden-admin-jail.conf"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "warden_admin_filter" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "vaultwarden-admin-filter.conf"
  source                 = "data/fail2ban/vaultwarden-admin-filter.conf"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "nginx_bot_jail" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "nginx-botsearch-jail.conf"
  source                 = "data/fail2ban/nginx-botsearch-jail.conf"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "nginx_http_auth_jail" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "nginx-http-auth-jail.conf"
  source                 = "data/fail2ban/nginx-http-auth-jail.conf"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "nginx_301_jail" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "nginx-301-jail.conf"
  source                 = "data/fail2ban/nginx-301-jail.conf"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "nginx_301_filter" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "nginx-301-filter.conf"
  source                 = "data/fail2ban/nginx-301-filter.conf"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "nginx_400_jail" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "nginx-400-jail.conf"
  source                 = "data/fail2ban/nginx-400-jail.conf"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "nginx_400_filter" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "nginx-400-filter.conf"
  source                 = "data/fail2ban/nginx-400-filter.conf"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "nginx_404_jail" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "nginx-404-jail.conf"
  source                 = "data/fail2ban/nginx-404-jail.conf"
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "nginx_404_filter" {
  bucket                 = aws_s3_bucket.config.id
  key                    = "nginx-404-filter.conf"
  source                 = "data/fail2ban/nginx-404-filter.conf"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_public_access_block" "config" {
  bucket                  = aws_s3_bucket.config.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "backup" {
  bucket                  = aws_s3_bucket.backup.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
