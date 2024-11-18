output "prom_graf_public_ip" {
  description = "Public IP address of the prom_graf server"
  value       = aws_instance.prom_graf.public_ip
}

output "nginx_server_public_ip" {
  description = "Public IP addresses of the nginx server instance"
  value       = aws_instance.nginx_server.public_ip
}