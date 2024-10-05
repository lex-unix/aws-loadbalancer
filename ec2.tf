resource "aws_key_pair" "deployer" {
  key_name   = "deployer"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "aws_ami" "ubuntu_nginx" {
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-nginx"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "ubuntu_base" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "web" {
  subnet_id              = aws_subnet.private1.id
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id]
  ami                    = data.aws_ami.ubuntu_nginx.id
  instance_type          = "t2.micro"
  user_data              = file("init.yaml")
  key_name               = aws_key_pair.deployer.key_name
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "8"
    delete_on_termination = true
  }
  tags = {
    Name = "web"
  }
}


resource "aws_instance" "bastion" {
  subnet_id                   = aws_subnet.public1.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  ami                         = data.aws_ami.ubuntu_base.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.deployer.key_name
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "8"
    delete_on_termination = true
  }
  tags = {
    Name = "bastion"
  }
}
