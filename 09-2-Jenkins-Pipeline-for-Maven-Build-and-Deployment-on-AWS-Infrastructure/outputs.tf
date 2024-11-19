output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = aws_subnet.public[*].id
}

output "internet_gateway_id" {
  description = "ID of the created Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "prod-security_group_id" {
  description = "ID of the created security group"
  value       = aws_security_group.prod-sg.id
}

output "jenkins-server" {
  description = "Public IP address of the jenkins server"
  value       = aws_instance.jenkins-server.public_ip
}

output "prod-server" {
  description = "Public IP address of the production server"
  value       = aws_instance.prod-server.public_ip
}