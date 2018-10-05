#!/usr/bin/env bash
#set -vx
#
# Script Name: 6_func_create_firehose_delivery_stream.sh
#
# Reference: Using CloudWatch Logs Subscription Filters.
# Using CloudWatch Logs Subscription Filters - Example 3: Subscription Filters with Amazon Kinesis Data Firehose:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#FirehoseExample
#
# 6 - Create a destination Kinesis Data Firehose delivery stream as follows, replacing the placeholder values for RoleARN and BucketARN with the role and bucket ARNs that you 
# created:
#
# 7 - Wait until the stream becomes active (this might take a few minutes). You can use the Kinesis Data Firehose describe-delivery-stream command to check the 
# DeliveryStreamDescription.DeliveryStreamStatus property. In addition, note the DeliveryStreamDescription.DeliveryStreamARN value, as you will need it in a later step:
#----------------------------------------------------------------------------------------------------------------
func_create_firehose_delivery_stream() {
REGION1=$(cat subscription.conf | grep "REGION1=" | cut -d "=" -f 2)
ACCOUNT_ID=$(cat subscription.conf | grep "ACCOUNT_ID=" | cut -d "=" -f 2)
MY_DELIVERY_STREAM_NAME=$(cat subscription.conf | grep "MY_DELIVERY_STREAM_NAME=" | cut -d "=" -f 2)
BUCKET_NAME=$(cat subscription.conf | grep "BUCKET_NAME=" | cut -d "=" -f 2)
ROLE_NAME_FIREHOSE=$(cat subscription.conf | grep "ROLE_NAME_FIREHOSE=" | cut -d "=" -f 2)
ROLE_NAME_CWL=$(cat subscription.conf | grep "ROLE_NAME_CWL=" | cut -d "=" -f 2)

export ACCOUNT_ID ROLE_NAME_FIREHOSE ROLE_NAME_ARN_CW 
BUCKET_ARN=arn:aws:s3:::$BUCKET_NAME
ROLE_NAME_ARN=arn:aws:iam::$ACCOUNT_ID\:role/$ROLE_NAME_FIREHOSE # I had to scape the ":" before role...

# Creating the Kinesis Firehose Delivery Data Stream  #6
TEST0=$(aws firehose list-delivery-streams --output text --region $REGION1 | awk '{print $2}' | grep $MY_DELIVERY_STREAM_NAME)
if [ -z $TEST0 ]
  then
    aws firehose create-delivery-stream --delivery-stream-name $MY_DELIVERY_STREAM_NAME --s3-destination-configuration RoleARN=$ROLE_NAME_ARN,BucketARN=$BUCKET_ARN --region $REGION1
    func_wait_to_be_active
else
  if [ "$MY_DELIVERY_STREAM_NAME" == "$TEST0" ]
    then
      echo "$(tput setaf 1) $(tput setab 7)✓  There is an Amazon Kinesis Firehose $MY_DELIVERY_STREAM_NAME running/creating or deleting on region $REGION1 $(tput sgr 0)"      
  fi
fi  

}

# Waiting the Kinesis Firehose Delivery Data Stream become active #7
func_wait_to_be_active(){
REGION1=$(cat subscription.conf | grep "REGION1=" | cut -d "=" -f 2)
MY_DELIVERY_STREAM_NAME=$(cat subscription.conf | grep "MY_DELIVERY_STREAM_NAME=" | cut -d "=" -f 2)

while :
do
  TEST1=$(aws firehose describe-delivery-stream --delivery-stream-name $MY_DELIVERY_STREAM_NAME --region $REGION1 --output text | grep DELIVERYSTREAMDESCRIPTION | awk '{print $5}')
  case $TEST1 in
"")
echo "$(tput setaf 1) $(tput setab 7)✓  There is no Amazon Kinesis Firehose $MY_DELIVERY_STREAM_NAME running on region $REGION1 $(tput sgr 0)"
    exit
;;
  CREATING)
    echo "$(tput setaf 1) $(tput setab 7)✓  CREATING  $a seconds $(tput sgr 0)"
    sleep 1
    ((a++))    
    clear	  
    func_wait_to_be_active
;;
  ACTIVE)
echo "$(tput setaf 1) $(tput setab 7)✓  The  Amazon Kinesis Firehose $MY_DELIVERY_STREAM_NAME is ACTIVE$(tput sgr 0)"
exit
;;  
  DELETING)
echo "$(tput setaf 1) $(tput setab 7)✓  Deleting the  Amazon Kinesis Firehose $MY_DELIVERY_STREAM_NAME $(tput sgr 0)"
exit
;;  
*)
echo "Nothing to do"
;;
  esac
done
echo 

}

func_create_firehose_delivery_stream
func_wait_to_be_active

