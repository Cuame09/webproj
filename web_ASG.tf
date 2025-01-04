
# Launch Template


resource "aws_launch_template" "web_template" {
  name          = "web_template"
  instance_type = "t2.micro"
  image_id      = "ami-0c76bd4bd302b30ec"
  key_name      = aws_key_pair.webprojkp.key_name
  user_data = base64encode(file("user_data.sh"))  # Include a user data script if applicable

  network_interfaces {
    security_groups             = [aws_security_group.web_sg.id]
    associate_public_ip_address = true
  }
}
 
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity    = 2
  min_size            = 1
  max_size            = 4
  health_check_type   = "EC2"
  vpc_zone_identifier = [aws_subnet.public-sub1.id, aws_subnet.public-sub2.id] # Public subnets for the web tier
  target_group_arns   = [aws_lb_target_group.lb-target-web.arn]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.web_template.id
      }

    }
  }
}

# resource "aws_autoscaling_attachment" "lb-target-web" {
#   autoscaling_group_name = aws_autoscaling_group.web_asg.id
# }


# resource "aws_lb_target_group_attachment" "lb-target-group" {
#   target_group_arn = aws_lb_target_group.lb-target-web.arn
#   target_id        = [aws_instance.web_Server1.id, aws_instance.web_Server2.id]
#   port             = 80
# }



# Autoscaling Policies (Optional: For dynamic scaling)
resource "aws_autoscaling_policy" "scale_out_policy_web" {
  name                   = "scale-out-web"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_policy" "scale_in_policy_web" {
  name                   = "scale-in-web"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}
