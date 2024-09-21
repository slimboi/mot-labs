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
3. Set up bucket policy for public access
4. Configure the bucket for static website hosting
5. Set up Route53 for custom domain (optional)
6. Configure security settings

## Detailed Instructions

### 1. Create an S3 bucket

1. Login to AWS console and click on Services, select S3 located under Storage.
2. Click on "Create bucket".
3. Give a unique name to your bucket. e.g cloudhight1285 
4. Ensure "ACLs disabled" is selected (this is the default).
5. Uncheck "Block all public access" and then acknowledge doing this.
6. Select "Disable versioning".
7. Add tags if desired. e.g cloudhight-project
8. For encryption, keep the defaults:
   - Server-side encryption with AWS S3 managed keys (SSE-S3)
   - Enable Bucket Key
9. Click "Create bucket".

![Bucket Creation](imgs/1.bucket_creation.png)

10. Create a folder to store logs of activities on your site:
    a. Click "Create folder"
    b. Name the folder "serverLogs"
    c. For Server-side encryption, keep the default "Don't specify an encryption key"
    d. Click "Create folder"

![Folder Creation](imgs/2.folder_creation.png)

11. Configure server access logging:
    a. Click on "Properties" tab
    b. Scroll down to "Server access logging" and click "Edit"
    c. Enable Server access logging
    d. Click on "Browse S3"
    e. Select your bucket
    f. Choose the "serverLogs" folder as the destination
    g. Keep the default for Log object key format
    h. Click on "Save changes"

![Server Logs](imgs/3.server_logs.png)

### 2. Upload your static website files

1. In your S3 bucket, click on "Objects" and then "Upload".
2. Click on "Add files" or "Add folder" to open your file explorer.
3. Select your static web content files and folders.
4. Drag and drop the selected files into the browser window or use the file selection dialog.
5. Click "Upload".
6. Once the files are uploaded, click "Close".

![Website Files](imgs/6.webfiles_upload.png)

### 3. Set up bucket policy for public access

1. Go to the "Permissions" tab of your bucket.
2. Scroll down to "Bucket policy" and click "Edit".
3. Click on "Policy generator".
4. In the policy generator, provide the following information:
   - Select Type of Policy: S3 bucket policy
   - Effect: Allow
   - Principal: *
   - Actions: GetObject
   - Amazon Resource Name (ARN): arn:aws:s3:::your-bucket-name/*
     (Replace "your-bucket-name" with your actual bucket name)
5. Click "Add Statement".
6. Click "Generate Policy".

![Policy Generation](imgs/4.policy_generation.png)

7. Copy the generated policy JSON document.
8. Go back to the "Edit bucket policy" page and paste the copied JSON.

![Policy Json](imgs/5.policy_json.png)

9. Click "Save changes".

### 4. Configure the bucket for static website hosting

1. Go to the bucket's "Properties" tab.
2. Scroll down to "Static website hosting" and click "Edit".
3. Choose "Enable" for static website hosting.
4. Set "Index document" to "index.html".
5. Set "Error document" to "error.html".
6. Click "Save changes".
7. Scroll down to "Static website hosting" and copy the URL generated.

![Static URL](imgs/7.static_url.png)

8. Put this into a web browser to view the website

![Website Display](imgs/8.website_display.png)