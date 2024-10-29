output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = aws_subnet.public[*].id
}
/*
output "private_subnet_ids" {
  description = "IDs of the created private subnets"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  description = "ID of the created NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}
*/

output "internet_gateway_id" {
  description = "ID of the created Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "maven-security_group_id" {
  description = "ID of the created security group"
  value       = aws_security_group.maven-sg.id
}

output "prod-security_group_id" {
  description = "ID of the created security group"
  value       = aws_security_group.prod-sg.id
}

output "maven-server" {
  description = "Public IP address of the control node"
  value       = aws_instance.maven-server.public_ip
}

output "prod-server" {
  description = "Public IP address of the Ubuntu managed node"
  value       = aws_instance.prod-server.public_ip
}

/*
output "redhat_managed_node_public_ip" {
  description = "Public IP address of the Red Hat managed node"
  value       = aws_instance.redhat_managed_node.public_ip
}
*/