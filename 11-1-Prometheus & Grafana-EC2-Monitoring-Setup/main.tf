terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "ofagbule-react-app"         # Replace with your actual bucket name
    key     = "ofagbule/terraform.tfstate" # Adjust the path accordingly
    region  = "eu-west-2"                  # Replace with your actual region
    encrypt = true                         # Enable encryption
    # dynamodb_table = "your-dynamodb-table"    # Optional for state locking
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Data source for availability zones in the region
data "aws_availability_zones" "available" {
  state = "available"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

# Create Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security group to allow port access to the Prometheus and Grafana EC2 instance
resource "aws_security_group" "prom_graf_sg" {
  name        = "${var.project_name}-prom_graf_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  # Allow SSH access
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow 9090 port access for Prometheus UI
  ingress {
    description = "Allow Access for Prometheus UI"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing access from all IPs
  }

  # Allow 9100 port for Node Exporter
  ingress {
    description = "Allow Access for Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing access from all IPs
  }

  # Allow 3000 port for Grafana UI
  ingress {
    description = "Allow Access for Grafana UI"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing access from all IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-prom_graf_sg"
  }
}

# Security group to allow ports for Nginx Server
resource "aws_security_group" "nginx_sg" {
  name        = "${var.project_name}-nginx_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  # Allow SSH access
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow 9100 port for Node Exporter
  ingress {
    description = "Allow Access for Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing access from all IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-nginx_sg"
  }
}

# Create a Key Pair to SSH into EC2 instance
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

# Store the private key locally
resource "local_file" "private_key" {
  filename        = "my_key_pair.pem"
  content         = tls_private_key.my_key.private_key_pem
  file_permission = "0400"
}

# Create Prometheus and Grafana EC2 Instance
resource "aws_instance" "prom_graf" {
  ami           = var.ubuntu_ami_id
  instance_type = var.medium_instance_type
  key_name      = aws_key_pair.key_pair.key_name
  subnet_id     = aws_subnet.public[0].id

  vpc_security_group_ids = [aws_security_group.prom_graf_sg.id]

  user_data = templatefile("./prom_graf.sh", {
    nginx_webserver_ip = aws_instance.nginx_server.public_ip
  })

  depends_on = [aws_instance.nginx_server]

  tags = {
    Name = "${var.project_name}-prom_graf"
  }
}

# Create Nginx EC2 Instance
resource "aws_instance" "nginx_server" {
  ami           = var.ubuntu_ami_id
  instance_type = var.micro_instance_type
  key_name      = aws_key_pair.key_pair.key_name
  subnet_id     = aws_subnet.public[0].id

  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  user_data = file("./nginx_userdata.sh")

  tags = {
    Name = "${var.project_name}-nginx_server"
  }
}