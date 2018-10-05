#!/usr/bin/env bash
#set -vx 
#
# Script Name: 11_func_create_log_group.sh
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
# 11 - Associate the permissions policy with the role using the put-role-policy command:
# OBS.: In case you have created the VPC flow logs via AWS WEB Console the log Group will be created by AWS on your behalf.
#----------------------------------------------------------------------------------------------------------------
func_create_log_group() {
# Creating Log Group to Flowlogs #12
LOG_GROUP_NAME=$(cat subscription.conf | grep "LOG_GROUP_NAME=" | cut -d "=" -f 2)
REGION1=$(cat subscription.conf | grep "REGION1=" | cut -d "=" -f 2)

echo "$(tput setaf 1) $(tput setab 7)✓   Creating Log Group in CloudWatch$(tput sgr 0)"
printf "\n"
aws logs create-log-group --log-group-name $LOG_GROUP_NAME --region $REGION1

export LOG_GROUP_NAME

}

func_create_log_group

# TODO point to the region you want to have the logs analysed. 
