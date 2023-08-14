resource "aws_instance" "web_instance" {
  ami                    = "ami-04e601abe3e1a910f" # Ubuntu 20.04 LTS
  instance_type          = "t2.micro"
  key_name               = "Agnija_aws_keys"
  vpc_security_group_ids = [aws_security_group.web_instance_security.id]


  tags = {
    Name = "PythonWebAppInstance"
  }

  connection {
    host        = aws_instance.web_instance.public_ip
    type        = "ssh"
    port        = 22
    user        = "ubuntu"
    private_key = file("~/Agnija_aws_keys.pem")
    timeout     = "5m"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y docker.io",
      "sudo usermod -aG docker ubuntu"
    ]
  }
}

resource "aws_security_group" "web_instance_security" {
  name = "PythonWebAppInstance_security"
  description = "Allow HTTP and SSH traffic via Terraform"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
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
