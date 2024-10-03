# Creating a Custom VPC in AWS

## Overview

Amazon Virtual Private Cloud (VPC) is a foundational AWS service that provides isolated cloud resources in a defined virtual network. This guide walks you through creating a custom VPC and deploying resources within it.

## Prerequisites

- Active AWS Account
- IAM user with appropriate permissions
- Basic understanding of networking concepts

## Features

- Custom IP address range (CIDR block)
- Public and private subnets
- Internet Gateway configuration
- Route tables and security groups
- NAT Gateway (optional)

## Step-by-Step Guide

### 1. VPC Creation
1. Navigate to VPC Dashboard in AWS Console
2. Choose the Region you want to create your VPC eg London
3. Click "Create VPC"
3. Configure basic settings:
   - Name tag eg ofagbule-vpc
   - IPv4 CIDR block (e.g., 10.0.0.0/16)
   - Tenancy option (Default)

![Create VPC](imgs/1.create_vpc.png)

### 2. Subnet Configuration
- Click on Subnets in the left panel
- Click on Create subnet
- Select your VPC
- Create public subnets for internet-facing resources
  - Subnet name eg ofagbule-pub-01
  - Availability Zone (eu-west-2a)
  - IPv4 VPC CIDR block (10.0.1.0/24)
- Click Add new subnet
- Create private subnets for internal resources
  - Subnet name eg ofagbule-prv-01
  - Availability Zone (eu-west-2a)
  - IPv4 VPC CIDR block (10.0.2.0/24)
- Click Create subnet

### 3. Security Setup
- Configure Network ACLs
- Set up Security Groups
- Establish VPC Flow Logs (optional)

## Best Practices

- Use meaningful tags for all resources
- Follow the principle of least privilege
- Implement proper subnet sizing
- Enable VPC Flow Logs for network monitoring
- Regular security audits

## Resources

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [VPC Pricing](https://aws.amazon.com/vpc/pricing/)
- [AWS Best Practices](https://aws.amazon.com/architecture/well-architected/)
