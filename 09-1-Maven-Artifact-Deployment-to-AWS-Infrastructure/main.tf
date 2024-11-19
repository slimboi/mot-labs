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

/*
# Create Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.project_name}-nat-gw"
  }
}

resource "aws_eip" "nat" {
  count  = 1
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}
*/

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

/*
# Create Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}
*/

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

/*
# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
*/

# Security group to allow SSH access to the Maven EC2 instance
resource "aws_security_group" "maven-sg" {
  name        = "${var.project_name}-maven-sg"
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-maven-sg"
  }
}

# Security group to allow SSH and port 8080 access to the Production EC2 instance
resource "aws_security_group" "prod-sg" {
  name        = "${var.project_name}-prod-sg"
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

  # Allow 8080 port access for Application
  ingress {
    description = "Allow HTTP"
    from_port   = 8080
    to_port     = 8080
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
    Name = "${var.project_name}-prod-sg"
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

/*
# Create Key Pair
 resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.public_key_path)
}
*/

# Create Maven EC2 Instance
resource "aws_instance" "maven-server" {
  ami           = var.redhat_ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name
  subnet_id     = aws_subnet.public[0].id

  vpc_security_group_ids = [aws_security_group.maven-sg.id]

  user_data = file("./maven-userdata.sh")

  tags = {
    Name = "${var.project_name}-maven-server"
  }
}

# Create Production EC2 Instance
resource "aws_instance" "prod-server" {
  ami           = var.redhat_ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name
  subnet_id     = aws_subnet.public[0].id

  vpc_security_group_ids = [aws_security_group.prod-sg.id]

  user_data = file("./prod-userdata.sh")

  tags = {
    Name = "${var.project_name}-prod-server"
  }
}

/*
# Create Red Hat Managed Node EC2 Instance
resource "aws_instance" "redhat_managed_node" {
  ami           = var.redhat_ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.main.key_name
  subnet_id     = aws_subnet.public[0].id

  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "${var.project_name}-redhat-managed-node"
  }
}
*/