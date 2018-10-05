#!/usr/bin/env bash
#set -vx
#
# Script Name: 4_func_create_permission_policy_to_firehose_role.sh
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
# 4 - Create a permissions policy to define what actions Kinesis Data Firehose can do on your account. First, use a text editor to create a permissions policy in a file 
# ~/PermissionsForFirehose.json:
#----------------------------------------------------------------------------------------------------
func_create_permission_policy_to_firehose_role() {
# Creating the Permission Policy  #4
BUCKET_NAME=$(cat subscription.conf | grep "BUCKET_NAME=" | cut -d "=" -f 2)

echo "$(tput setaf 1) $(tput setab 7)✓   Creating the Permission Policy$(tput sgr 0)"
echo ""
echo "{
  "\"Statement\"": [
    {
      "\"Effect\"": "\"Allow\"",
      "\"Action\"": [
          "\"s3:AbortMultipartUpload\"",
          "\"s3:GetBucketLocation\"",
          "\"s3:GetObject\"",
          "\"s3:ListBucket\"",
          "\"s3:ListBucketMultipartUploads\"",
          "\"s3:PutObject\"" ],
      "\"Resource\"": [
          "\"arn:aws:s3:::$BUCKET_NAME\"",
          "\"arn:aws:s3:::$BUCKET_NAME/*\"" ]
    }
  ]
}" > /var/tmp/PermissionsForFirehose.json

if [ -e /var/tmp/PermissionsForFirehose.json ]
  then 
    printf "The file /var/tmp/PermissionsForFirehose.json was successfully created\n"
  else 
    printf "The file was not created, please check if the file system is full or if you have permission to write at the destination /var/tmp\n"
fi

}

func_create_permission_policy_to_firehose_role
