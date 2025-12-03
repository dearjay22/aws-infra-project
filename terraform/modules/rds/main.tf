resource "aws_db_instance" "mysql" {
  identifier              = "prog8870-mysql"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.db_instance_class
  db_name                 = var.db_name != "" ? var.db_name : null
  username                = var.db_username
  password                = var.db_password
  # public accessibility per project spec (only for lab)
  publicly_accessible     = true
  skip_final_snapshot     = true

  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name

  tags = {
    Name = "prog8870-rds"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "prog8870-db-subnet-group-${random_id.suffix.hex}"
  subnet_ids = var.db_subnet_ids
  tags = { Name = "prog8870-db-subnet-group" }
}

resource "random_id" "suffix" {
  byte_length = 2
}