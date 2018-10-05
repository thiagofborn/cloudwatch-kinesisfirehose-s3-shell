#!/usr/bin/env bash
#set -vx
#
# Script Name: 7_func_create_trust_policy_cloudwatch_role.sh
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
# 8 - Create the IAM role that will grant CloudWatch Logs permission to put data into your Kinesis Data Firehose delivery stream. First, use a text editor to create a trust policy 
# in a file ~/TrustPolicyForCWL.json:
# OBS.: The script is number 7 however it is the step 8 from the documentation
#----------------------------------------------------------------------------------------------------------------
func_create_trust_policy_cloudwatch_role() {
# TODO:  verify the region and provide options to configure
# Creating IAM role that will grant CloudWatch Logs permission to put data into your Kinesis Firehose delivery stream #8
echo "$(tput setaf 1) $(tput setab 7)✓   Creating IAM role that will grant Cloudwatch Logs permission to put data into your Kinesis Firehose delivery stream$(tput sgr 0)"
printf "\n"
echo "{
  "\"Statement\"": {
    "\"Effect\"": "\"Allow\"",
    "\"Principal\"": { "\"Service\"": "[" "\"logs.eu-west-1.amazonaws.com\"", "\"logs.eu-west-2.amazonaws.com\"", "\"vpc-flow-logs.amazonaws.com\"" "]"},
    "\"Action\"": "\"sts:AssumeRole\""
  }
}" > /var/tmp/TrustPolicyForCWL.json

if [ -e /var/tmp/TrustPolicyForCWL.json ]
  then 
    printf "The file /var/tmp/TrustPolicyForCWL.json was successfully created\n"
  else 
    printf "The file was not created, please check if the file system is full or if you have permission to write at the destination\n"
fi

}

func_create_trust_policy_cloudwatch_role
