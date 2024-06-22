resource "aws_security_group" "public_ssh" {

  name        = "${var.resource_prefix}ssh"
  description = "Allow ssh connectivity to host"
  vpc_id      = aws_vpc.this.id

  tags = merge(
    var.default_tags, {
      Name = "public-ssh"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.public_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv6" {
  security_group_id = aws_security_group.public_ssh.id
  cidr_ipv6         = "::/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_security_group" "public_https" {

  name        = "${var.resource_prefix}https"
  description = "Allow https connectivity to host"
  vpc_id      = aws_vpc.this.id

  tags = merge(
    var.default_tags, {
      Name = "${var.resource_prefix}public-https-v4",
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.public_https.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv6" {
  security_group_id = aws_security_group.public_https.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_security_group" "public_http" {

  name        = "${var.resource_prefix}http"
  description = "Allow http connectivity to host"
  vpc_id      = aws_vpc.this.id

  tags = merge(
    var.default_tags, {
      Name = "${var.resource_prefix}public-http",
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.public_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv6" {
  security_group_id = aws_security_group.public_http.id
  cidr_ipv6         = "::/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_security_group" "vpc_traffic" {
  name        = "${var.resource_prefix}vpc-traffic"
  description = "Allow all VPC traffic"
  vpc_id      = aws_vpc.this.id

  tags = merge(
    var.default_tags, {
      Name = "${var.resource_prefix}private-vpc-traffic",
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_vpc_ipv4" {
  security_group_id = aws_security_group.vpc_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_vpc_ipv6" {
  security_group_id = aws_security_group.vpc_traffic.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}
