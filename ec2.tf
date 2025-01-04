# INSTANCES

# WEB SERVERS INSTANCES

resource "aws_instance" "web_server1" {
  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-sub1.id
  key_name                    = aws_key_pair.webprojkp.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data = base64encode(file("user_data.sh"))
  tags = {
    Name = "web-server1"
  }

}

resource "aws_instance" "web_server2" {
  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-sub2.id
  key_name                    = aws_key_pair.webprojkp.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data = base64encode(file("user_data2.sh"))  # Include a user data script if applicable

  tags = {
    Name = "web-server2"
  }

}

# APP SERVERS INSTANCES

resource "aws_instance" "app_server1" {
  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private-sub1.id
  key_name                    = aws_key_pair.webprojkp.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id, aws_security_group.lb_sg.id, aws_security_group.db_sg.id]
  associate_public_ip_address = false
  
  tags = {
    Name = "App-server1"
  }

}

resource "aws_instance" "app_server2" {
  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private-sub2.id
  key_name                    = aws_key_pair.webprojkp.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id, aws_security_group.lb_sg.id, aws_security_group.db_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "App-server2"
  }

}