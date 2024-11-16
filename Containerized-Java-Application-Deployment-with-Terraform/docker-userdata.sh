#!/bin/bash
# Step 1: Update the system
sudo yum update -y
sudo yum upgrade -y

# Step 2: Install required packages
sudo yum install -y yum-utils

# Step 3: Set up the Docker CE repository for RHEL
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Step 4: Install Docker CE
sudo yum install docker-ce -y

# Step 5: Start and enable the Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Step 6: Add ec2-user to the docker group (optional, allows running Docker without sudo)
sudo usermod -aG docker ec2-user
