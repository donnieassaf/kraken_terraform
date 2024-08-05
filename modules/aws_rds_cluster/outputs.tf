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

output "db_endpoint" {
  description = "The endpoint of the RDS cluster"
  value       = aws_rds_cluster.main.endpoint
}

output "db_username" {
  description = "The master username for the RDS cluster"
  value       = aws_rds_cluster.main.master_username
}

output "db_password" {
  description = "The master password for the RDS cluster"
  value       = var.master_password
}

output "db_name" {
  description = "The name of the database"
  value       = aws_rds_cluster.main.database_name
}
