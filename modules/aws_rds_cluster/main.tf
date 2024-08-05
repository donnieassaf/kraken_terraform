resource "aws_rds_cluster" "main" {
  cluster_identifier      = "${var.environment}auroracluster"
  engine                  = "aurora-postgresql"
  master_username         = var.master_username
  master_password         = var.master_password
  database_name           = "${var.environment}dbcluster"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.main.id]
  apply_immediately       = true
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "writer" {
  cluster_identifier      = aws_rds_cluster.main.id
  instance_class          = var.instance_class
  engine                  = aws_rds_cluster.main.engine
  engine_version          = aws_rds_cluster.main.engine_version
  identifier              = "${var.environment}-writer"
  publicly_accessible     = false
  apply_immediately       = true
}

resource "aws_rds_cluster_instance" "reader" {
  cluster_identifier      = aws_rds_cluster.main.id
  instance_class          = var.instance_class
  engine                  = aws_rds_cluster.main.engine
  engine_version          = aws_rds_cluster.main.engine_version
  identifier              = "${var.environment}-reader"
  publicly_accessible     = false
  apply_immediately       = true
}
