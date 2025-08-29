provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("${path.module}/my-key.pub")
}

resource "aws_security_group" "ssh_access" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami             = "ami-0c02fb55956c7d316"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.ssh_access.name]

  tags = {
    Name        = "DatadogMonitoredEC2"
    Environment = "Dev"
  }

  user_data = templatefile("${path.module}/install.sh.tpl", {
  dd_api_key = var.datadog_api_key
})

}


