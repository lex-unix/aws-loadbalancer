output "lb_dns_name" {
  description = "Load balancer DNS name"
  sensitive   = false
  value       = aws_lb.lb.dns_name
}
