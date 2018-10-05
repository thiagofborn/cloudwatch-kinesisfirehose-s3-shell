#!/usr/bin/env bash
#set -vx
#
# Script Name: Delete resources created based on the subscription.conf 
#
#
#----------------------------------------------------------------------------------------------------------------
BUCKET_NAME=$(cat subscription.conf | grep "BUCKET_NAME=" | cut -d "=" -f 2)
REGION1=$(cat subscription.conf | grep "REGION1=" | cut -d "=" -f 2)
ROLE_NAME_FIREHOSE=$(cat subscription.conf | grep "ROLE_NAME_FIREHOSE" | cut -d "=" -f 2)
ROLE_NAME_CWL=$(cat subscription.conf | grep "ROLE_NAME_CWL=" | cut -d "=" -f 2)
LOG_GROUP_NAME=$(cat subscription.conf | grep "LOG_GROUP_NAME=" | cut -d "=" -f 2)
MY_DELIVERY_STREAM_NAME=$(cat subscription.conf | grep "MY_DELIVERY_STREAM_NAME=" | cut -d "=" -f 2)


echo "$(tput setaf 1) $(tput setab 7)✓  Deleting the resources $BUCKET_NAME, $MY_DELIVERY_STREAM_NAME, $LOG_GROUP_NAME, $ROLE_NAME_FIREHOSE, $ROLE_NAME_CWL on region $REGION1  $(tput sgr 0)"
aws s3 rb s3://$BUCKET_NAME --force --region $REGION1
aws firehose delete-delivery-stream --delivery-stream-name $MY_DELIVERY_STREAM_NAME --region $REGION1
aws logs delete-log-group --log-group-name $LOG_GROUP_NAME --region $REGION1
aws iam delete-role-policy --role-name $ROLE_NAME_FIREHOSE --policy-name Permissions-Policy-For-Firehose --region $REGION1
aws iam delete-role-policy --role-name $ROLE_NAME_CWL --policy-name Permissions-Policy-For-CWL --region $REGION1
aws iam delete-role --role-name $ROLE_NAME_FIREHOSE --region $REGION1
aws iam delete-role --role-name $ROLE_NAME_CWL --region $REGION1

echo "$(tput setaf 1) $(tput setab 7)✓  The VPC Flow Logs is still there, you need to delete it in case it was created manually.  $(tput sgr 0)"
echo "$(tput setaf 1) $(tput setab 7)✓  The same action needs to be done in case you have configured the AWS Cloudtrail.  $(tput sgr 0)"
