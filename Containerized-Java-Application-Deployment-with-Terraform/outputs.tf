output "maven-server" {
  description = "Public IP address of the maven server"
  value       = aws_instance.maven-server.public_ip
}

output "docker-server" {
  description = "Public IP address of the production server"
  value       = aws_instance.docker-server.public_ip
}