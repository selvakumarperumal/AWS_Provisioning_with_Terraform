output "zone_id" {
  description = "Route 53 hosted zone ID"
  value       = module.dns.zone_id
}

output "name_servers" {
  description = "Name servers — update these at your domain registrar"
  value       = module.dns.name_servers
}

output "a_record_fqdn" {
  description = "FQDN of the A record"
  value       = module.dns.a_record_fqdn
}

output "www_cname_fqdn" {
  description = "FQDN of the www CNAME"
  value       = module.dns.www_cname_fqdn
}
