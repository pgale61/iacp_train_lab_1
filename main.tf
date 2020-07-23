provider "aws" {
  region     = var.region
}

data "aws_ami" "the_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*" ]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = [ "099720109477" ]
}

data "aws_subnet_ids" "scalr_ids" {
  vpc_id = var.vpc
}

data "aws_security_group" "default_sg" {
  name = "default"
  vpc_id = var.vpc
}

resource "aws_instance" "scalr" {
  ami                    = data.aws_ami.the_ami.id
  instance_type          = var.instance_type
  subnet_id              = element(tolist(data.aws_subnet_ids.scalr_ids.ids),0)
  vpc_security_group_ids = [ data.aws_security_group.default_sg.id ]
}
