terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
}

resource "aws_key_pair" "tf-deployer" {
  key_name   = "ubuntu-ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoHz2UAYZGnVgXGC2XTUJRTOfR8OEEivHTkf405A+9/+yrgBPLsjGBbuyE5GTioSe7MH93kibCihMTpTY4nY06MYQ9MGFsjM7CMoy8LdGHY6BvizXYyjWE3VlJVwrL8xPbACrmwwqlBHqVNx1V7SIpZizEoO3ODnUK0r68BfBNx3bdzPtMeIvo9yqlhWpVMKpLmtZy/7P5oVzsEqNULQxfoBZOzYM7H6ncwsdOFBTMFohPAl73+8uS85VwMo2uQahqdNFHLeHHimJIlWp8dhutRcYqtf5hbOI7Gs+ujcRDiVh5l+KT7s3t0JI4F6NQ//XQPLpiJGYrHEUITiisrOeVJormSRGQ2URFR4yWidOwTPvM4ytC46bWeBz18GtP6lDW6sqekliG6LGpRPn+USYsPmh92tltZR15INJ3njkAkRYPmhgtDCtQ8lfu/i/EujvNZxMqmRf/0/WtkI0OUMjf8MBsAQGllUpsu/ZCG5uVao0/kzK15JVutaaxmdh0+216HhvhL9cVuHCPRDXHqLv7WYAEVrQolVQnuJriJXs9lzhJpKkJmkwQS/v9plLRj53JlUGXIPywC/vXlV9+xWoMqP845DAOy8DFV3Qv8D8X1CsLfS6SewxAx+b8P4sYe0olj2m7h5+4aYRWiaLLnmTsMEluaKqnfxycaQ1zHvsz4w== user@ubuntu"
}

resource "aws_security_group" "tf-sg" {
  name = "tf-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "tf_ubuntu_server" {
  ami           = data.aws_ami.ubuntu.id        # value from data fetch manifest
  instance_type = "t3.micro"
  count = 1
  key_name = "ubuntu-ssh-key"
  vpc_security_group_ids = [aws_security_group.tf-sg.id]

  tags = {
    Name = "tf_ubuntu_server"
  }
}
