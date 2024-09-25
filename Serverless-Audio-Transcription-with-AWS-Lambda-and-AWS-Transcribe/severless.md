# Serverless Audio Transcription with AWS Lambda and AWS Transcribe

This project demonstrates how to create a serverless solution that automatically processes audio data uploaded to an S3 bucket using AWS Lambda and AWS Transcribe.

## Overview

Automating processes is a cornerstone of cloud computing. This solution automatically transcribes audio files into text whenever they are uploaded to an S3 bucket, saving time and effort for each new file.

## Prerequisites

- AWS Account
- Audio file for testing: `ImportantBusiness.mp3`
  - Download link: [ImportantBusiness.mp3](https://raw.githubusercontent.com/linuxacademy/content-aws-mls-c01/master/AutomaticallyProcessS3DataUsingLambda/ImportantBusiness.mp3)


## Setup Instructions

### 1. Create an IAM Role

1. Open the AWS Management Console
2. Search for "IAM" in the search bar
3. Click on the IAM service
4. Click on "Roles" and then click on "Create role"
5. Do the following:
   - Select "AWS Service"
   - Click the drop-down for "Service or use case" and select "Lambda"
   - Click "Next"
   - In the search bar, type "S3" and select "AmazonS3FullAccess"
   - In the search bar, type "Transcribe" and select "AmazonTranscribeFullAccess"
   - In the search bar, type "CloudWatchFullAccess" and select "CloudWatchFullAccess"
   - Click "Next"
   - Give the name "transcribe-meeting-role" to your role 
   - Add a tag to your role (e.g., Key: app, Value: meeting-transcriber)
   - Click "Create role"
6. The role should be created successfully and listed when "Roles" is clicked

![Transcribe Role Display](imgs/1.role_display.png)
