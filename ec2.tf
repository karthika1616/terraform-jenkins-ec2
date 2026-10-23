
resource "aws_instance" "jenkins" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  # Install Jenkins automatically using install.sh
  user_data = file("${path.module}/install.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "Jenkins-server"
  }

  vpc_security_group_ids = [
    aws_security_group.jenkins_sgs.id
  ]

  # Wait for Jenkins and retrieve the initial admin password
  provisioner "remote-exec" {
    inline = [
      "sleep 450",
      "sudo test -f /var/lib/jenkins/secrets/initialAdminPassword",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /tmp/jenkins_password.txt",
      "sudo chown ubuntu:ubuntu /tmp/jenkins_password.txt",
      "chmod 600 /tmp/jenkins_password.txt"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/jenkins.pem")
      host        = self.public_ip
      timeout     = "10m"
    }
  }

  # Copy the password file to your local JENKINS folder
  provisioner "local-exec" {
    command = "scp -i \"${path.module}/jenkins.pem\" -o StrictHostKeyChecking=no ubuntu@${self.public_ip}:/tmp/jenkins_password.txt \"${path.module}/jenkins_password.txt\""
  }
}
