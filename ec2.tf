resource "aws_key_pair" "deployer" {
  key_name   = "deployer"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "web1" {
  subnet_id              = aws_subnet.private1.id
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id, aws_security_group.allow_ping.id]
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.micro"
  user_data              = file("init.yaml")
  key_name               = aws_key_pair.deployer.key_name
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "8"
    delete_on_termination = true
  }
  tags = {
    Name = "web-1"
  }
}


resource "aws_instance" "bastion" {
  subnet_id              = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id]

  associate_public_ip_address = true
  ami                         = "ami-0866a3c8686eaeeba"
  instance_type               = "t2.micro"
  user_data                   = file("init.yaml")
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
