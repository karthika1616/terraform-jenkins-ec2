
resource "aws_security_group" "jenkins_sgs" {
  name        = "jenkins-sgs"
  description = "Allow Jenkins web access and restricted SSH"

  ingress {
    description = "SSH from your current public IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["106.51.59.174/32"]
  }

  ingress {
    description = "Jenkins web interface"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-Security-Group"
  }
}
