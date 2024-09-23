resource "aws_security_group" "k8s_sg" {
  name        = "k8s-security-group"
  description = "Allow SSH and Kubernetes traffic"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443  # Porta API Kubernetes
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
}

resource "aws_key_pair" "k8s_key" {
  key_name   = "k8s_key"
  public_key = file("C:\\Users\\biond\\.aws\\aws_k8s_cluster\\key.pem.pub")  #Percorso corretto della chiave pubblica
}

resource "aws_instance" "manager" {
  ami           = "ami-033067239f2d2bfbc"
  instance_type = var.instance_type
  count         = 1
  security_groups = [aws_security_group.k8s_sg.name]
  key_name      = aws_key_pair.k8s_key.key_name

  tags = {
    Name = "k8s-manager"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y epel-release
              yum install -y ansible
              EOF
}

resource "aws_instance" "workers" {
  ami           = "ami-033067239f2d2bfbc"
  instance_type = var.instance_type
  count         = 2
  security_groups = [aws_security_group.k8s_sg.name]
  key_name      = aws_key_pair.k8s_key.key_name

  tags = {
    Name = "k8s-worker"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y epel-release
              yum install -y ansible
              EOF
}