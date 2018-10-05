#!/usr/bin/env bash
#set -vx
#
# Script Name: 5_func_add_permission_policy_to_firehose_role.sh
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
# 5 - Associate the permissions policy with the role using the following put-role-policy command:
#----------------------------------------------------------------------------------------------------------------
func_add_permission_policy_to_firehose_role() {
# Creating a variable to keep the Role ARN to be used at the step "create-delivery-stream" #5
ROLE_NAME_FIREHOSE=$(cat subscription.conf | grep "ROLE_NAME_FIREHOSE=" | cut -d "=" -f 2)
BUCKET_NAME=$(cat subscription.conf | grep "BUCKET_NAME=" | cut -d "=" -f 2)
ROLE_NAME_ARN=$(aws iam list-roles --query 'Roles[].[Arn]' --output text | grep $ROLE_NAME_FIREHOSE)
BUCKET_ARN=arn:aws:s3:::$BUCKET_NAME

# Adding the Permission Policy to the Role #6
echo "$(tput setaf 1) $(tput setab 7)✓   Adding the Permission Policy to the Role$(tput sgr 0)"
printf "\n"
aws iam put-role-policy \
--role-name $ROLE_NAME_FIREHOSE \
--policy-name Permissions-Policy-For-Firehose \
--policy-document file:///var/tmp/PermissionsForFirehose.json > /dev/null 2>&1
    
}

func_get_policy_from_firehose_role(){
ROLE_NAME_FIREHOSE=$(cat subscription.conf | grep "ROLE_NAME_FIREHOSE=" | cut -d "=" -f 2)

   sleep 2 # wait for the policy role
   aws iam get-role-policy --role-name $ROLE_NAME_FIREHOSE  --policy-name Permissions-Policy-For-Firehose

}

func_add_permission_policy_to_firehose_role
func_get_policy_from_firehose_role
