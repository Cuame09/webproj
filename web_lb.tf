
resource "aws_lb" "web_lb" {
  name                             = "web-lb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.web_sg.id, aws_security_group.lb_sg.id]
  subnets                          = [aws_subnet.public-sub1.id, aws_subnet.public-sub2.id]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "lb-target-web" {
  name     = "lb-target-web"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.WEB-PROJ-vpc.id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "web_tg_attachmentA" {
  target_group_arn = aws_lb_target_group.lb-target-web.arn
  target_id        = aws_instance.web_server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_tg_attachmentB" {
  target_group_arn = aws_lb_target_group.lb-target-web.arn
  target_id        = aws_instance.web_server2.id
  port             = 80
}



resource "aws_lb_listener" "lb-listener-web" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target-web.arn
  }
}