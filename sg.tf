# SECURITY GROUPS

# Web Server Security Group

resource "aws_security_group" "web_sg" {
  vpc_id      = aws_vpc.WEB-PROJ-vpc.id
  name        = "web_sg"
  description = "Security group for web server"

# Allow inbound HTTP traffic on port 80
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  # Allows traffic from any IP address
   
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["81.107.76.128/32"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


# App Server Security Group

 resource "aws_security_group" "app_sg" {
   name        = "app-sg"
   vpc_id      = aws_vpc.WEB-PROJ-vpc.id
   description = "Allow traffic from host server"

   ingress {
     from_port       = 80
     to_port         = 80
     protocol        = "tcp"
     cidr_blocks = [ "0.0.0.0/0" ]
   }

 # Allow inbound HTTPS traffic on port 443
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere
 }   

# Allow inbound DB traffic from the DB security group (e.g., MySQL on port 3306)
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
      # Reference DB security group
  }

   # Allow outbound traffic to anywhere (default)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All traffic allowed
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_sg"
  }
}


# database Server Security Group

 resource "aws_security_group" "db_sg" {
   name        = "db_sg"
   description = "Security group for RDS database"
   vpc_id      = aws_vpc.WEB-PROJ-vpc.id


   ingress {
    description     = "Allow MySQL access from app servers"
     from_port       = 3306
     to_port         = 3306
     protocol        = "tcp"
    
   }

   egress {
    description = "Allow all outbound traffic"
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }
 
}

# Security Group for Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Security group for the Load Balancer"
  vpc_id      = aws_vpc.WEB-PROJ-vpc.id

  # Allow inbound HTTP traffic from anywhere
  ingress {
    description      = "Allow HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  # Allow outbound traffic to any destination
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "lb_sg"
  }
}

resource "aws_security_group_rule" "allow_lb_health_checkA" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.lb_sg.id
}


resource "aws_security_group_rule" "allow_lb_health_checkB" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.lb_sg.id
}
