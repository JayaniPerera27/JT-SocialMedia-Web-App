provider "aws" {
  region = "eu-north-1"  # Set AWS region to Europe (Stockholm)
}

# Security Group that allows SSH, HTTP, and HTTPS access
resource "aws_security_group" "web_sg" {
  name        = "JT-social-media"
  description = "Allow HTTP, HTTPS, and SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["212.104.231.122/32"]  # Replace with your trusted IP for SSH access
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access from any IP
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS access from any IP
  }

  # Custom port (e.g., for application running on port 5000 or 3000)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust the source IPs if needed
  }

  # Allow communication between instances
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Fetch the Ubuntu 22.04 AMI from AWS SSM Parameter Store
data "aws_ssm_parameter" "ubuntu_22_04_ami" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# EC2 instance for the Social Media Web App
resource "aws_instance" "web" {
  ami           = data.aws_ssm_parameter.ubuntu_22_04_ami.value
  instance_type = "t3.micro"
  key_name      = "JT-web-app"

  # Associate the EC2 instance with the security group
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "JT-social-media"
  }

  # Provisioning to setup the application (Optional)
  provisioner "local-exec" {
    command = <<-EOT
      # Additional provisioning commands can be placed here if needed
    EOT
    interpreter = ["PowerShell", "-Command"]
  }
}

# SSH Key Pair for the instance
resource "aws_key_pair" "deployer" {
  key_name   = "JT-web-app"
  public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0nZ9Kz2fXi7jp0g20f9u
AmfyRZd142xn6I1gg6DOhb08jwK6d/UOb4rYqAHiLFmmObhVSM2JpjaQMMz2aKCE
1Er/t6mHRV4LtB9rWurMmaju4w5ORZe4ywtkG7tA+RrAwqwm988HstHQJEv345iu
iC3gnJMLiED8agqwySpDBECaVGWN3WVAiu2fq3/CCNT9+ugdgbEfERI4OcOAvSq0
F7QeblwA9Ykoe8hT838WLuVSsiHNJWBQNF5xU4lmzxzkPerEw0NQhOSaLLY8SiEL
CQtOMvtHAROg4y/qFYxg+yJtU05/iB/rrXMhQnxstcfrMWycGguY863IVIwvMuRa
1wIDAQAB"
}

# Output the public IP of the instance
output "server_ip" {
  value = aws_instance.web.public_ip
}
