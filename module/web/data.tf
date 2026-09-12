data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # canonical owner-id of ubuntu in aws ami list
  filter {
    name = "name"           
    values = ["ubuntu-*"]
  }                         
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {                         # filter out ubuntu images based on criterias
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}
