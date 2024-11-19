output "master-node_public_ip" {
  description = "Public IP address of the master-node"
  value       = aws_instance.master-node.public_ip
}

output "worker_node_public_ips" {
  description = "Public IP addresses of the worker node instances"
  value       = aws_instance.worker-node[*].public_ip
}