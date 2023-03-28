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
  key_name               = "keypair"
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "Yash-Gurukul"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXIFO0eny+VCc8XvQdPzkKaX5LXT9b6FHJB25GjLJ2kMhb3n/8SAH0d9JVY8H4DsoTwh50iq1nB08HLhjiXdBH/NGWl3sOX3iQnjlTC+RkVpqaSD0oDWJ+gGbyK53YbagFvoUv+sHd6qwxFgxiKFFfBMYP+f1KBL5ipI1ew6izG/CXodsf0Ezy1+e3JJ2lYETSTZAvWRkfU+WOMIwH896ccSFtCVf3BHy1MnNLmDbRNi9i0+OKksKrCcDb+SPc6hvXaZj/RJSoyCavrTvtAqb5Tb4KUH0eAqMBGHuG49JdE9GV4dLUDHw6NWKHYnHhRtwsCPd3bxCFSqOV145WawRr yashn@Yashs-MacBook-Pro.local"
}
