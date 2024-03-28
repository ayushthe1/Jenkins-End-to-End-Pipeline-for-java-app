variable "ami_id" {
  type = string
  description = "ami id for the ec2 instance"
}

variable "instance_type" {
  type = string
  description = "type of the ec2 instance"
}

variable "tag_name" {
  type = string 
}

variable "ec2_sg_name" {
  type = string
}

variable "public_key" {
    type = string
}

variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}