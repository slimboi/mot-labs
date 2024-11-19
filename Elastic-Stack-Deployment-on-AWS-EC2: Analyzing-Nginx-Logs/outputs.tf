output "elk_server_public_ip" {
  description = "Public IP address of the elk_server server"
  value       = aws_instance.elk_server.public_ip
}

output "nginx_server_public_ip" {
  description = "Public IP addresses of the nginx server instance"
  value       = aws_instance.nginx_server.public_ip
}