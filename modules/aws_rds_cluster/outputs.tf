output "security_group_id" {
  description = "The ID of the security group attached to the RDS Cluster"
  value       = aws_security_group.main.id
}

output "endpoint" {
  description = "The DNS address of the RDS cluster"
  value       = aws_rds_cluster.main.endpoint
}

output "reader_endpoint" {
  description = "The DNS address of the read replica"
  value       = aws_rds_cluster.main.reader_endpoint
}
