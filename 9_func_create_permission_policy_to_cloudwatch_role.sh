#!/usr/bin/env bash
#set -vx
#
# Script Name: 9_func_create_permission_policy_to_cloudwatch_role.sh
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
# 10 - Create a permissions policy to define what actions CloudWatch Logs can do on your account. First, use a text editor to create a permissions policy file 
# (for example, ~/PermissionsForCWL.json):
#----------------------------------------------------------------------------------------------------------------
func_create_permission_policy_to_cloudwatch_role() {
# Creating a Permission Policy to the CloudWatchLogs Role #10
REGION1=$(cat subscription.conf | grep "REGION1=" | cut -d "=" -f 2)
ACCOUNT_ID=$(cat subscription.conf | grep "ACCOUNT_ID" | cut -d "=" -f 2)
ROLE_NAME_CWL=$(cat subscription.conf | grep "ROLE_NAME_CWL=" | cut -d "=" -f 2)
ROLE_NAME_ARN_CWL=$(cat subscription.conf | grep "ROLE_NAME_ARN_CWL=" | cut -d "=" -f 2)

echo "$(tput setaf 1) $(tput setab 7)✓   Creating a Permission Policy to the CloudWatchLogs Role put$(tput sgr 0)"
printf  "\n"
echo "{
    "\"Version\"": "\"2012-10-17\"",
    "\"Statement\"": [
        {
            "\"Action\"": [
                "\"firehose:*\"",
                "\"logs:CreateLogGroup\"",
                "\"logs:CreateLogStream\"",
                "\"logs:PutLogEvents\"",
                "\"logs:DescribeLogGroups\"",
                "\"logs:DescribeLogStreams\""
            ],
            "\"Effect\"": "\"Allow\"",
            "\"Resource\"": "\"*\""
        }
    ]
}" > /var/tmp/PermissionsForCWL.json

if [ -e /var/tmp/PermissionsForCWL.json ]
  then 
    printf "The file /var/tmp/PermissionsForCWL.json was successfully created\n"
  else 
    printf "The file was not created, please check if the file system is full or if you have permission to write at the destination\n"
fi

}
func_create_permission_policy_to_cloudwatch_role
