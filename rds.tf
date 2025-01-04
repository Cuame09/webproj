# RDS Instance
resource "aws_db_instance" "web-proj-database" {
  identifier             = "web-proj-database"
  skip_final_snapshot    = true
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  db_name                = "user_database"
  username               = "admin"
  password               = "webproj1234"
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name

  tags = {
    Name = "WEB-PROJ-database"
  }
}


# Subnet Group for RDS
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.private-sub3.id, aws_subnet.private-sub4.id]
}