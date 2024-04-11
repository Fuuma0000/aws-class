// modules/ec2/main.tf

#----------------------------------------
# EC2インスタンスの作成
#----------------------------------------
resource "aws_instance" "apache" {
  ami                    = "ami-09d28faae2e9e7138" # Amazon Linux 2
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  tags = {
    Name = var.name
  }
  disable_api_termination = true
  user_data              = <<-EOF
    #! /bin/bash
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
  EOF
}
