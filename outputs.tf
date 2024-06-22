output "admin-token" {
  value = random_string.admin-token.result
}

output "full-domain-name" {
  value = local.full_domain_name
}
