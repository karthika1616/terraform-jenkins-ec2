
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
  default     = "jenkins"
}


variable "ami" {
  description = "Ubuntu 24.04 AMI ID in ap-south-1"
  type        = string
  default     = "ami-094adff9b24048c5c"
}
