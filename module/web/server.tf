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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/H0cJFaVeFLZ+vN6KErOIJ9VYwuS4siuXDt9Po+NJdvaSkE4kP5s3EZwN9cgbQtL+i4iN4HEKmmo9gMDwyzBNofqPCtLYWY9E4ijO3E1qOXlz571qPscX4D1bVPIf3Bd1bwmJiaefRC6nCJNMerKXYymXQ5UjJ+4RfZxFRuTAlOyARaOSPFd7wfgZwldTX6RGQ+/XmVYkkf4JMt2+TOb6y2GwE8GIVwlT0QP7lyhXayxuw2tM/6LItfOhFs+L5qaq9muAd7N+j1wiiJHhxYkfBaJhzqaHV7auw6yQcFYfJg8/w4ViVQW5S4tV+lWlSOsQEyxaUPq1lrS8nubWEovd"
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
