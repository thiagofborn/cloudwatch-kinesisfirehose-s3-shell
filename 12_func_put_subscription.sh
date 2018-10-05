#!/usr/bin/env bash
#set -vx 
#
# Script Name: 12_func_put_subscription.sh
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
# 12 - After the Amazon Kinesis Data Firehose delivery stream is in active state and you have created the IAM role, you can create the 
# CloudWatch Logs subscription filter. The subscription filter immediately starts the flow of real-time log data from the chosen 
# log group to your Amazon Kinesis Data Firehose delivery stream:
#----------------------------------------------------------------------------------------------------------------
func_put_subscription() {
# Observation:  In this script there are two different regions. It means that is possible to deliver VPC flow logs from one region to a Firehose in another region.
# Creating Put-Subscription #13
LOG_GROUP_NAME=$(cat subscription.conf | grep "LOG_GROUP_NAME=" | cut -d "=" -f 2)
DESTINATION_NAME=$(cat subscription.conf | grep "DESTINATION_NAME=" | cut -d "=" -f 2)
ACCOUNT_ID=$(cat subscription.conf | grep "ACCOUNT_ID" | cut -d "=" -f 2)
MY_DELIVERY_STREAM_NAME=$(cat subscription.conf | grep "MY_DELIVERY_STREAM_NAME=" | cut -d "=" -f 2)
ROLE_NAME_CWL=$(cat subscription.conf | grep "ROLE_NAME_CWL=" | cut -d "=" -f 2)
ROLE_NAME_ARN_CWL=arn:aws:iam::$ACCOUNT_ID\:role/$ROLE_NAME_CWL
REGION1=$(cat subscription.conf | grep "REGION1=" | cut -d "=" -f 2)

echo "$(tput setaf 1) $(tput setab 7)✓   Creating Put-Subscription$(tput sgr 0)"
printf "\n"
aws logs put-subscription-filter --log-group-name "$LOG_GROUP_NAME" \
--filter-name "$DESTINATION_NAME" \
--filter-pattern "AllTraffic" \
--destination-arn "arn:aws:firehose:$REGION1:$ACCOUNT_ID:deliverystream/$MY_DELIVERY_STREAM_NAME" \
--role-arn $ROLE_NAME_ARN_CWL \
--region $REGION1;

echo "$(tput setaf 1) $(tput setab 7)✓  The log Group Name is: $LOG_GROUP_NAME  $(tput sgr 0)"
}

func_put_subscription


# TODO point to the region situation and clarify it.
# Sometimes it happens, however if we re-execute the step 12 it works. 
# An error occurred (InvalidParameterException) when calling the PutSubscriptionFilter operation: Could not deliver test message to specified Firehose stream. Check if the given Firehose stream is in ACTIVE state. 
#silvathi@c4b301b84d6b  ~/Downloads  cat flowlogsUnified-1-2018-05-10-20-17-24-15a366a3-0254-4bd9-9e3e-69c3cbb79075| zcat                                                                                   # {"messageType":"CONTROL_MESSAGE","owner":"CloudwatchLogs","logGroup":"","logStream":"","subscriptionFilters":[],"logEvents":[{"id":"","timestamp":1525983444232,"message":"CWL CONTROL MESSAGE: Checking health of destination Firehose."}]}%

