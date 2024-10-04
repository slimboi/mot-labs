# AWS Application Load Balancer Setup Guide

## What is an Application Load Balancer?
An Application Load Balancer (ALB) is a sophisticated Layer 7 load balancing service provided by AWS. It functions by:
- Distributing incoming application traffic across multiple targets (EC2 instances, containers, IP addresses) in multiple Availability Zones
- Supporting content-based routing, where requests are routed based on the content of the request (URL path, host headers, HTTP headers)
- Offering advanced features like:
  - SSL/TLS termination
  - WebSocket support
  - HTTP/2 support
  - Protection against DDoS attacks when used with AWS Shield
  - Integration with AWS WAF for enhanced security

### Key Benefits
1. **High Availability**: Automatically distributes traffic across multiple AZs
2. **Automatic Scaling**: Works seamlessly with Auto Scaling groups
3. **Health Monitoring**: Continuously checks target health and routes traffic only to healthy targets
4. **Security**: Provides enhanced security with built-in SSL/TLS termination
5. **Cost Efficiency**: Pay only for what you use, with no upfront fees

## Prerequisites
- Active AWS Account
- Basic understanding of AWS EC2 service
- Understanding of basic networking concepts

## Infrastructure Overview
This guide walks through setting up an Application Load Balancer (ALB) with two EC2 instances running Apache web servers. The ALB will distribute traffic between these instances, providing high availability and fault tolerance.

### Architecture Diagram
```
                                   ┌──────────────────┐
                                   │                  │
                              ┌────►  Web Server 01   │
                              │    │                  │
┌──────────────┐    ┌─────────┴──┐ └──────────────────┘
│              │    │             │
│    Client    ├────►     ALB     │
│              │    │             │
└──────────────┘    └─────────┬──┘ ┌──────────────────┐
                              │    │                  │
                              └────►  Web Server 02   │
                                   │                  │
                                   └──────────────────┘
```

## EC2 Instance Setup

### Common Configuration for Both Instances
1. Navigate to EC2 Dashboard → Launch Instance
2. Configure base settings:
   - AMI: Red Hat Enterprise Linux
   - Instance Type: t2.micro (Free Tier eligible)
   - Key Pair: Create new or select existing

### Network Settings
- VPC: Your custom VPC
- Subnet: Public subnet
- Auto-assign Public IP: Enable
- Security Group: Use existing frontend security group (`ofagbule-frontend-sg`)

### Instance 1: Web Server 01
1. Name: `apache-webserver-01`
2. Under Advanced Details, add the following User Data script:
```bash
#!/bin/bash
#sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo chkconfig httpd on
echo "<html><h1>Olawale Slimboi Web Server 01</h1></html>" > /var/www/html/index.html
```

### Instance 2: Web Server 02
1. Name: `apache-webserver-02`
2. Use identical configuration as Instance 1, but with this User Data script:
```bash
#!/bin/bash
#sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo chkconfig httpd on
echo "<html><h1>Olawale Slimboi Web Server 02</h1></html>" > /var/www/html/index.html
```

## Verification
1. Wait for both instances to launch and pass status checks
2. Copy the public IP address of each instance
3. Paste each IP address into a web browser
4. Verify that you see the corresponding web server message for each instance

![Web Server 1](imgs/1.web_server_1.png)

![Web Server 2](imgs/2.web_server_2.png)
