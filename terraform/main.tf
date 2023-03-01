provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "sandbox"
  vpc_security_group_ids = ["${aws_security_group.sandbox.id}"]
  tags = {
    Name = "ubuntu_ansible_managed_node"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/sandbox.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo adduser ansiadmin --gecos 'ANSI Admin,,,' --disabled-password",
      "sudo echo 'ansiadmin:ansible123' | sudo chpasswd",
      "sudo usermod -aG sudo ansiadmin",
      "sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config",
      "sudo sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config",
      "sudo hostnamectl set-hostname amazon_managed_node",
      "sudo systemctl restart sshd"
    ]
  }
}

resource "aws_security_group" "sandbox" {
  name_prefix = "sandbox"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


