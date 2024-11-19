#!/bin/bash

# Update package lists
sudo apt-get update

# Install Nginx
sudo apt-get install nginx -y

# Add Elasticsearch GPG key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# Install transport protocol for HTTPS repositories
sudo apt-get install apt-transport-https

# Add Elasticsearch repository
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

# Update package lists again
sudo apt-get update

# Install Filebeat
sudo apt-get install filebeat

# Modify Filebeat configuration
sudo sed -i 's/output.elasticsearch:/#output.elasticsearch:/g' /etc/filebeat/filebeat.yml
sudo sed -i 's/hosts: \["localhost:9200"\]/#hosts: ["localhost:9200"]/g' /etc/filebeat/filebeat.yml
sudo sed -i 's/#output.logstash:/output.logstash:/g' /etc/filebeat/filebeat.yml
sudo sed -i 's/#hosts: \["localhost:5044"\]/hosts: ["${elk_server_ip}:5044"]/g' /etc/filebeat/filebeat.yml

# Enable Nginx module in Filebeat
sudo filebeat modules enable nginx

# Start and enable Filebeat service
sudo systemctl start filebeat.service
sudo systemctl enable filebeat.service
