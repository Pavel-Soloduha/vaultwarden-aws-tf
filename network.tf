data "aws_route53_zone" "this" {
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.full_domain_name
  type    = "A"
  ttl     = "60"
  records = [aws_eip.this.public_ip]
}

resource "aws_network_interface" "this" {
  security_groups = [
    aws_security_group.public_ssh.id,
    aws_security_group.public_https.id,
    aws_security_group.public_http.id,
    aws_security_group.vpc_traffic.id
  ]
  subnet_id         = aws_subnet.this.id
  source_dest_check = true
  description       = "ENI for vaultwarden"
  tags = merge(
    var.default_tags, {
      Name = "vw-interface"
    }
  )
}

resource "aws_eip" "this" {
  network_interface = aws_network_interface.this.id
  tags = merge(
    var.default_tags, {
      Name = "vw-eip"
    }
  )
}
