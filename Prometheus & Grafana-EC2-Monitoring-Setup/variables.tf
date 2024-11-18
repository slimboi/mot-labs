variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "ofagbule-project"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default     = "my_key_pair"
}

variable "ubuntu_ami_id" {
  description = "AMI ID for Ubuntu instances"
  type        = string
  default     = "ami-0e8d228ad90af673b" # Ubuntu 24.04 LTS (HVM), SSD Volume Type
}

variable "redhat_ami_id" {
  description = "AMI ID for Red Hat instances"
  type        = string
  default     = "ami-07d1e0a32156d0d21" # Red Hat Enterprise Linux 9 (HVM), SSD Volume Type
}

variable "medium_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "micro_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
