#!/bin/bash
# Update the system
yum update -y

# Install Nginx
yum install -y nginx

# Start Nginx
service nginx start

# Ensure Nginx starts on boot
chkconfig nginx on

# Optionally, create a custom HTML page
echo "<html><body><h1>Welcome to Nginx on EC2!</h1></body></html>" > /usr/share/nginx/html/index.html
