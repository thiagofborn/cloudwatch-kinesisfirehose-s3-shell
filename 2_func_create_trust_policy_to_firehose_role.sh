#!/usr/bin/env bash
#set -vx
#
# Script Name: 2_func_create_trust_policy_to_firehose_role.sh
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
# 2 - Create the IAM role that will grant Amazon Kinesis Data Firehose permission to put data into your Amazon S3 bucket.
# For more information, see Controlling Access with Amazon Kinesis Data Firehose in the Amazon Kinesis Data Firehose Developer Guide.
# First, use a text editor to create a trust policy in a file ~/TrustPolicyForFirehose.json as follows, replacing account-id with your AWS account ID:
#----------------------------------------------------------------------------------------------------
func_create_trust_policy_to_firehose_role() {
# Creating the Trust Policy File to be added to the Role responsible to assume the the Service "firehose.amazonaws.com" #2
ACCOUNT_ID=$(cat subscription.conf | grep "ACCOUNT_ID" | cut -d "=" -f 2)

echo "$(tput setaf 1) $(tput setab 7)✓   Creating the Trust Policy File to be added to the Role responsible to assume the the Service "\"firehose.amazonaws.com\""$(tput sgr 0)"
printf "\n"
echo "{
  "\"Statement\"": {
    "\"Effect\"": "\"Allow\"",
    "\"Principal\"": { "\"Service\"": "\"firehose.amazonaws.com\"" },
    "\"Action\"": "\"sts:AssumeRole\"",
    "\"Condition\"": { "\"StringEquals\"": { "\"sts:ExternalId\"":"\"$ACCOUNT_ID\"" } }
  }
}" > /var/tmp/TrustPolicyForFirehose.json

if [ -e /var/tmp/TrustPolicyForFirehose.json ]
  then 
    printf "The file /var/tmp/TrustPolicyForFirehose.json was successfully created\n"
  else 
    printf "The file was not created, please check if the file system is full or if you have permission to write at the destination\n"
fi

}

func_create_trust_policy_to_firehose_role
