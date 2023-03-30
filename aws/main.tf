terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket  = "yash-gurukul-bucket"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_subnet" "yash-public-subnet" {
  vpc_id                  = "vpc-019c09a1a0c5b4f6b"
  cidr_block              = "10.0.0.48/28"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "yash-public-subnet"
  }
}

resource "aws_security_group" "main" {
  vpc_id = "vpc-019c09a1a0c5b4f6b"
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}

resource "aws_instance" "app_server" {
  ami                    = "ami-00c39f71452c08778"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.yash-public-subnet.id
  key_name               = "yash-key"
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "Yash-Gurukul"
  }
}
