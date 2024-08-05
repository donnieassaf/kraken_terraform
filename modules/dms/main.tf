


resource "aws_dms_replication_instance" "main" {
  replication_instance_class = "dms.t3.medium"
  allocated_storage          = 100
  replication_instance_id    = "${var.environment}-dms-instance"
  vpc_security_group_ids     = var.db_security_group_id
  publicly_accessible        = false
  apply_immediately          = true
}


resource "aws_dms_endpoint" "source" {
  endpoint_id            = "${var.environment}-db-source-endpoint"
  endpoint_type          = "source"
  engine_name            = "aurora-postgresql"
  username               = var.db_username
  password               = var.db_password
  server_name            = var.db_endpoint
  port                   = 5432
  database_name          = var.db_name
  ssl_mode               = "require" 
}