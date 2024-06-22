data "aws_route53_zone" "this" {
  name         = var.hosted_zone
  private_zone = false
}
