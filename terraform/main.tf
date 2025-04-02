provider "aws" {
  region = "eu-north-1"  # Set AWS region to Europe (Stockholm)
}

# Security Group that allows SSH, HTTP, and HTTPS access
resource "aws_security_group" "web_sg" {
  name        = "JT-social-media"
  description = "Allow HTTP, HTTPS, and SSH inbound traffic"

  # SSH access (replace with your trusted IP for better security)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["212.104.231.122/32"]  # Your trusted IP for SSH access
  }

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Custom port for application
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Fetch the Ubuntu 22.04 AMI
data "aws_ssm_parameter" "ubuntu_22_04_ami" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# Create SSH key pair
resource "aws_key_pair" "deployer" {
  key_name   = "JT-web-app"
  
  # Replace this with your actual public key in OpenSSH format
  # The key should start with "ssh-rsa" and be a single line
  public_key = "ssh-rsa MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0nZ9Kz2fXi7jp0g20f9u
AmfyRZd142xn6I1gg6DOhb08jwK6d/UOb4rYqAHiLFmmObhVSM2JpjaQMMz2aKCE
1Er/t6mHRV4LtB9rWurMmaju4w5ORZe4ywtkG7tA+RrAwqwm988HstHQJEv345iu
iC3gnJMLiED8agqwySpDBECaVGWN3WVAiu2fq3/CCNT9+ugdgbEfERI4OcOAvSq0
F7QeblwA9Ykoe8hT838WLuVSsiHNJWBQNF5xU4lmzxzkPerEw0NQhOSaLLY8SiEL
CQtOMvtHAROg4y/qFYxg+yJtU05/iB/rrXMhQnxstcfrMWycGguY863IVIwvMuRa
1wIDAQAB" 
}

# EC2 instance for the Social Media Web App
resource "aws_instance" "web" {
  ami           = data.aws_ssm_parameter.ubuntu_22_04_ami.value
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer.key_name
  
  # Use VPC security group IDs instead of names
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  # Enable public IP
  associate_public_ip_address = true
  
  tags = {
    Name = "JT-social-media"
  }

  # User data for initial setup (alternative to remote-exec)
  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y docker.io docker-compose
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker ubuntu
  EOF

  # Connection details for remote-exec (if needed)
  # connection {
  #   type        = "ssh"
  #   user        = "ubuntu"
  #   private_key = file("~/.ssh/JT-web-app.pem")  # Path to your private key
  #   host        = self.public_ip
  #   timeout     = "4m"
  # }
}

# Elastic IP for the instance (optional but recommended for production)
resource "aws_eip" "web_eip" {
  instance = aws_instance.web.id
  domain   = "vpc"
}

# Output the public IP of the instance
output "server_ip" {
  value = aws_eip.web_eip.public_ip
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
  description = "The public IP of the EC2 instance (without Elastic IP)"
}