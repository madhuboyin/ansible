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


