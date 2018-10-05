#!/usr/bin/env bash
#set -vx
#
# Script Name: 8_func_create_cloudwatch_role.sh
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
# 9 - Use the create-role command to create the IAM role, specifying the trust policy file. Note of the returned Role.Arn value, as you will need it in a later step:
#----------------------------------------------------------------------------------------------------------------
func_create_cloudwatch_role() {
# Creating a Role with a Trust Policy attached #8
ROLE_NAME_CWL=$(cat subscription.conf | grep "ROLE_NAME_CWL=" | cut -d "=" -f 2)

echo "$(tput setaf 1) $(tput setab 7)✓   Creating a Role with a Trust Policy attached$(tput sgr 0)"
printf "\n"
aws iam create-role --role-name $ROLE_NAME_CWL --assume-role-policy-document file:///var/tmp/TrustPolicyForCWL.json

}

func_list_cloudwatch_role(){
ROLE_NAME_CWL=$(cat subscription.conf | grep "ROLE_NAME_CWL=" | cut -d "=" -f 2)

    echo "$(tput setaf 1) $(tput setab 7)✓   Listing role created to CloudWatch$(tput sgr 0)"
    aws iam get-role --role-name $ROLE_NAME_CWL

}

func_create_cloudwatch_role
func_list_cloudwatch_role
