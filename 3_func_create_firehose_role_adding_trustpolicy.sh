#!/usr/bin/env bash
#set -vx
#
# Script Name: 3_func_create_firehose_role_adding_trustpolicy.sh
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
# 3 - Use the create-role command to create the IAM role, specifying the trust policy file. Note of the returned Role.Arn value, as you will need it in a later step:
#----------------------------------------------------------------------------------------------------
func_create_firehose_role_adding_trustpolicy() {
ROLE_NAME_FIREHOSE=$(cat subscription.conf | grep "ROLE_NAME_FIREHOSE=" | cut -d "=" -f 2)

# Creating Role and adding the Trust Policy #3
echo "$(tput setaf 1) $(tput setab 7)✓   Creating Role and adding the Trust Policy$(tput sgr 0)"
printf "\n"
aws iam create-role \
--role-name $ROLE_NAME_FIREHOSE \
--assume-role-policy-document file:///var/tmp/TrustPolicyForFirehose.json > /dev/null 2>&1 

}

func_list_firehose_role(){
ROLE_NAME_FIREHOSE=$(cat subscription.conf | grep "ROLE_NAME_FIREHOSE=" | cut -d "=" -f 2)

    echo "$(tput setaf 1) $(tput setab 7)✓   Listing role that has been created$(tput sgr 0)"
    aws iam get-role --role-name $ROLE_NAME_FIREHOSE

}

func_create_firehose_role_adding_trustpolicy
func_list_firehose_role
