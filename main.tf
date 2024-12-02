resource "aws_instance" "jenkins" {
  ami           = "ami-0166fe664262f664c" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = var.key_name

  user_data = file("bootstrap.sh")

  security_groups = [aws_security_group.jenkins.name]

  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_security_group" "jenkins" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.163.198.122/32"] # Your IP for SSH access
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world on port 8080
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

resource "aws_s3_bucket" "jenkins_artifacts" {
  bucket = "jenkins-artifacts-${random_id.bucket_id.hex}"

  tags = {
    Name        = "Jenkins-Artifacts"
    Environment = "Dev"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 8
}
