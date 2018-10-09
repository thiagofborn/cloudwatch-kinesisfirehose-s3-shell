#!/usr/bin/env bash
#set -vx
#
# Script Name: 0_s3_final_destination.sh 
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
#----------------------------------------------------------------------------------------------------------------

./1_func_create_bucket_to_the_subscription_process.sh
./2_func_create_trust_policy_to_firehose_role.sh
./3_func_create_firehose_role_adding_trustpolicy.sh
./4_func_create_permission_policy_to_firehose_role.sh
./5_func_add_permission_policy_to_firehose_role.sh
./6_func_create_firehose_delivery_stream.sh
./7_func_create_trust_policy_cloudwatch_role.sh
./8_func_create_cloudwatch_role.sh
./9_func_create_permission_policy_to_cloudwatch_role.sh
./10_func_add_permission_policy_to_cloudwatch_role.sh
./11_func_create_log_group.sh
echo "$(tput setaf 1) $(tput setab 7)✓  Every attemp of Put Log Subscription fails when I have tried to put via script immediatelly after the create_log_group function so... I will wait 10 seconds and if it fails please retry the script 12_func_put_subscription.sh. By excuting it ./12_func_put_subscription.sh .$(tput sgr 0)"
sleep 10 
./12_func_put_subscription.sh 
# For some unknown reason the first attempt always fails
# I am afraid the creation of the log groups takes a while to get ready



 