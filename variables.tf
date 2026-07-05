variable "project" {
    default = "roboshop"
  
}

variable "environment" {
    default = "dev"
  
}

variable "cidr_block" {

    default = "0.0.0.0/16"
  
}

variable "public_cidr" {
    default = "10.0.1.0/24"
  
}

variable "availability_zone" {
    default = "us-east-1a"
  
}
variable "instance_type" {
    default = "t3.micro"
  
}

