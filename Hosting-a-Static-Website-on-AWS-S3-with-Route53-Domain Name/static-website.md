# Hosting a Static Website on AWS S3 with Route53 Domain Name

## Overview
This guide explains how to host a static website using Amazon S3 (Simple Storage Service) and set up a custom domain name with Amazon Route53.

## What is a Static Website?
A static website consists of HTML, CSS, JavaScript, images, and other files that don't require server-side processing. This is in contrast to dynamic websites that generate content on-the-fly using server-side applications.

## Why Use Amazon S3 for Static Website Hosting?

Amazon S3 offers several advantages for hosting static websites:

1. **Unlimited Storage**: No restrictions on the amount of content you can host.
2. **High Durability**: 99.999999999% durability (1 in 10,000 objects lost every 10 million years).
3. **Scalability**: Easily handles high traffic spikes without additional configuration.
4. **Cost-Effective**: Pay only for what you use, with a generous free tier for small websites.
5. **AWS Integration**: Seamlessly works with other AWS services like CloudFront (CDN) and Lambda.

## Requirements

- An AWS Account
- Static web content (HTML, CSS, JavaScript, images, etc.)
- A registered domain name (optional, for custom domain setup)

## Setup Steps

1. Create an S3 bucket
2. Upload your static website files
3. Configure the bucket for static website hosting
4. Set up Route53 for custom domain (optional)
5. Configure security settings

## Detailed Instructions

### 1. Create an S3 bucket
