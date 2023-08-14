provider "aws" {
  profile = "default"
  region  = "eu-west-1"
  version = "~> 2.49"
}

resource "aws_key_pair" "example" {
  key_name   = "examplekey"
  public_key = file("~/.ssh/terraform.pub")
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
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

resource "aws_instance" "example" {
  key_name               = aws_key_pair.example.key_name
  ami                    = "ami-099a8245f5daa82bf"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  # subnet_id = "subnet-6f86e027"

  # user_data = <<-EOF
  #             #!/bin/bash
  #             echo "Hello, World" > index.html
  #             nohup busybox httpd -f -p 8080 &
  #             EOF

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/terraform")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
    ]
  }

  # The security group solution is an Excerpt From:
  # Yevgeniy Brikman. “Terraform: Up & Running, 2nd Edition”. Apple Books.
