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
  public_key = "aws-pulic-key"
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
