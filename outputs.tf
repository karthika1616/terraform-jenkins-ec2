
output "instance_id" {
  description = "ID of the Jenkins EC2 instance"
  value       = aws_instance.jenkins.id
}

output "public_ip" {
  description = "Public IPv4 address of the Jenkins EC2 instance"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_url" {
  description = "Jenkins web interface URL"
  value       = "http://${aws_instance.jenkins.public_ip}:8080"
}
