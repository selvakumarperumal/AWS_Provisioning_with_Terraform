output "zone_id" {
  description = "The hosted zone ID"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "Name servers for the hosted zone"
  value       = aws_route53_zone.main.name_servers
}

output "a_record_fqdn" {
  description = "FQDN of the A record"
  value       = length(aws_route53_record.a_record) > 0 ? aws_route53_record.a_record[0].fqdn : null
}

output "www_cname_fqdn" {
  description = "FQDN of the www CNAME record"
  value       = aws_route53_record.www_cname.fqdn
}

output "health_check_id" {
  description = "ID of the health check"
  value       = length(aws_route53_health_check.main) > 0 ? aws_route53_health_check.main[0].id : null
}
