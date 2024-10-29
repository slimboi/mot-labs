#!/bin/bash
# Update and refresh repository metadata
sudo yum update -y
sudo yum makecache fast

# Install Java, Git, and Maven
sudo yum install -y java-11-openjdk-devel
sudo yum install -y git
sudo yum install -y maven  # If this doesn't work, try 'sudo yum install -y apache-maven'