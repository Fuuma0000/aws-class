// modules/ec2/main.tf

#----------------------------------------
# EC2インスタンスの作成
#----------------------------------------
resource "aws_instance" "instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_pair_name
  tags = {
    Name = var.name
  }
  user_data = <<-EOF
    #! /bin/bash
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
  EOF
}
