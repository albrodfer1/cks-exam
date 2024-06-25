provider "aws" {
  region = var.aws_region
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cks" {
  key_name   = "cks-key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_vpc" "cks_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cks-vpc"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_vpc.cks_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.cks_vpc.id

  tags = {
    Name = "cks-vpc"
  }
}

resource "aws_subnet" "cks_subnet" {
  vpc_id            = aws_vpc.cks_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "cks-subnet"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "cks_sg" {
  vpc_id = aws_vpc.cks_vpc.id
  name   = "cks-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip_range]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip_range]
  }

  # Self-referencing ingress rule to allow traffic within the same security group
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "cks_instance1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.cks.key_name
  subnet_id                   = aws_subnet.cks_subnet.id
  security_groups             = [aws_security_group.cks_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "cks-instance-1"
  }
}

resource "aws_instance" "cks_instance2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.cks.key_name
  subnet_id                   = aws_subnet.cks_subnet.id
  security_groups             = [aws_security_group.cks_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "cks-instance-2"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

output "instance1_public_ip" {
  value = aws_instance.cks_instance1.public_ip
}

output "instance2_public_ip" {
  value = aws_instance.cks_instance2.public_ip
}

output "ssh_private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}