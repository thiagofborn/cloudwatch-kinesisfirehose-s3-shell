#!/usr/bin/env bash
#set -vx
# Script Name: 0_main.sh
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
# 0 - Call all the scripts 
#----------------------------------------------------------------------------------------------------

func_create_bucket_to_the_subscription_process() {
# Creating the S3 Bucket to keep the logs from Cloudwatch  #1 
BUCKET_NAME=$(cat subscription.conf | grep "BUCKET_NAME=" | cut -d "=" -f 2)
REGION1=$(cat subscription.conf | grep "REGION1=" | cut -d "=" -f 2)

echo "$(tput setaf 1) $(tput setab 7)✓   Creating the S3 Bucket to keep the logs from Cloudwatch$(tput sgr 0)"
aws s3api create-bucket --bucket $BUCKET_NAME --create-bucket-configuration LocationConstraint=$REGION1
aws s3 ls | grep $BUCKET_NAME 

}

func_create_bucket_to_the_subscription_process
