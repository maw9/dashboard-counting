output "dashboard-domain-name" {
  value = aws_route53_record.counting-record.fqdn
}