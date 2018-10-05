#!/usr/bin/env bash
#set -vx 
#
# Script Name: 10_func_add_permission_policy_to_cloudwatch_role.sh
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
# 10 - Create a permissions policy to define what actions CloudWatch Logs can do on your account. First, use a text editor to create a permissions policy file 
# (for example, ~/PermissionsForCWL.json):
#----------------------------------------------------------------------------------------------------------------
func_add_permission_policy_to_cloudwatch_role() {
# Associate the permissions policy with the role using the put-role-policy command: #11
ROLE_NAME_CWL=$(cat subscription.conf | grep "ROLE_NAME_CWL=" | cut -d "=" -f 2)

echo "$(tput setaf 1) $(tput setab 7)✓    Associate the permissions policy with the role using the "\"put-role-policy\"" command$(tput sgr 0)"
printf "\n"
aws iam put-role-policy \
	--role-name $ROLE_NAME_CWL \
	--policy-name Permissions-Policy-For-CWL \
	--policy-document file:///var/tmp/PermissionsForCWL.json
}

func_list_cloudwatch_role(){
    echo "$(tput setaf 1) $(tput setab 7)✓   Listing role created to CloudWatch$(tput sgr 0)"
    aws iam get-role --role-name $ROLE_NAME_CWL

}

func_add_permission_policy_to_cloudwatch_role
func_list_cloudwatch_role
