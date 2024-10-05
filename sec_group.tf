resource "aws_security_group" "allow_ssh" {
  name   = "allow_ssh"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_ssh.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "allow-ssh-ingress"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_ssh.id
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "allow-ssh-egress"
  }
}

resource "aws_security_group" "allow_http" {
  name   = "allow_http"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "allow-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_http.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "allow-http-ingress"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_http.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "allow-http-egress"
  }
}


resource "aws_security_group" "allow_ping" {
  name   = "allow_ping"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "allow-ping"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ping" {
  security_group_id = aws_security_group.allow_ping.id
  ip_protocol       = "icmp"
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "allow-ping-ingress"
  }
}
