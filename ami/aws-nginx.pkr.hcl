packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "nginx" {
  profile       = "lexunix-dev"
  ami_name      = "ubuntu-nginx"
  instance_type = "t2.micro"
  region        = "us-east-1"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  vpc_filter {
    filters = {
      "tag:Name" : "main",
      "isDefault" : "false",
    }
  }

  subnet_filter {
    filters = {
      "tag:Name" : "public-us-east-1b"
    }
  }

  ssh_username = "ubuntu"
}

build {
  name = "ubuntu-nginx"
  sources = [
    "source.amazon-ebs.nginx"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "mkdir -p /var/www/html"
    ]
  }
}
