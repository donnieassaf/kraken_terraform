# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get the default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group for RDS
resource "aws_security_group" "main" {
  name        = "rds-sg"
  vpc_id      = data.aws_vpc.default.id
  description = "Allow access to RDS"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# DB Subnet Group for RDS
resource "aws_db_subnet_group" "main" {
  name       = "rds-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
  tags = {
    Name = "rds-subnet-group"
  }
}
