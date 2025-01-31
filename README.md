
### cloudwatch-kinesisfirehose-s3-shell
This script helps create an environment to test the *AWS Cloudwatch* logs subscription filter to *AWS Kinesis Firehose Delivery Data Stream* using an *AWS S3 bucket* as the final destination. My Linux friends motivated me to adopt the shell script for this test environment. Since I love Linux, let me try it with a shell script. I kept it as simple as possible. I hope you can take something from it.

Please note that we are not covering any type of data transformation. Additionally, you need to push the load stream to the log group as the final action. 

For instance, if you want to push *AWS Cloudtrail* events to the log group, you will need to go the AWS Web console then select the trail and point the train to send data to the log group defined on your *subscription.conf* file. 

---
 1 - Cloudtrail: From your AWS Web Console go to Cloudtrail and click *View trails*.
![Cloudtrail Configuration](https://github.com/thiagofborn/cloudwatch-kinesisfirehose-s3-shell/blob/master/images/cloudtrail-0.png "Cloudtrail Events")

 2 - Cloudtrail: Select the trail you want to delivery to S3 bucket by clicking the link of the trail
![Cloudtrail Configuration](https://github.com/thiagofborn/cloudwatch-kinesisfirehose-s3-shell/blob/master/images/cloudtrail-1.png "Cloudtrail Events")

3 - Cloudtrail: Select the log group and the role
![Cloudtrail Configuration](https://github.com/thiagofborn/cloudwatch-kinesisfirehose-s3-shell/blob/master/images/cloudtrail-2.png "Cloudtrail Events")

---

In case you want to push *VPC Flow logs* to the log group, please go to your AWS Web console, select the VPC you want to have the logs being streamed, click the tab *Flow Logs*. 

1 - VPC Flow Logs: Tick the VPC you want to create the flow logs and click the tab *Flow Logs"
![Flow Logs Configuration](https://github.com/thiagofborn/cloudwatch-kinesisfirehose-s3-shell/blob/master/images/flow-0.png "VPC Flow Logs")

 2 - VPC Flow Logs: Select if you want "All Traffic", "Accepted" or "Rejected"
![Flow Logs Configuration](https://github.com/thiagofborn/cloudwatch-kinesisfirehose-s3-shell/blob/master/images/flow-1.png "VPC Flow Logs")

 3 - VPC Flow Logs: Select the Log Group Created by the Script
![Flow Logs Configuration](https://github.com/thiagofborn/cloudwatch-kinesisfirehose-s3-shell/blob/master/images/flow-2.png "VPC Flow Logs")

 4 - VPC Flow Logs: Select the *Cloudwatch* role created by the Script
![Flow Logs Configuration](https://github.com/thiagofborn/cloudwatch-kinesisfirehose-s3-shell/blob/master/images/flow-3.png "VPC Flow Logs")

---

### Simplified Diagram

![Diagram](https://github.com/thiagofborn/cloudwatch-kinesisfirehose-s3-shell/blob/master/images/simplified-diagram.png "Diagram is showing VPC and Cloudtrail as options")

---
### Pre-requisites
You need to have AWS CLI configured with a profile that can execute the commands, and a operating system that has the shell *BASH* installed. 

### How it works
---
The script: 0_s3_final_destination.sh calls all the other scripts as follows:

```
1_func_create_bucket_to_the_subscription_process.sh
2_func_create_trust_policy_to_firehose_role.sh
3_func_create_firehose_role_adding_trustpolicy.sh
4_func_create_permission_policy_to_firehose_role.sh
5_func_add_permission_policy_to_firehose_role.sh
6_func_create_firehose_delivery_stream.sh
7_func_create_trust_policy_cloudwatch_role.sh
8_func_create_cloudwatch_role.sh
9_func_create_permission_policy_to_cloudwatch_role.sh
10_func_add_permission_policy_to_cloudwatch_role.sh
11_func_create_log_group.sh
12_func_put_subscription.sh
```

The script receives the values from the file and executes each script that is composed by shell scripts commands and AWS CLI commands to create the test environment. 

## Using the script 
1 - Clone the repository
```
git clone https://github.com/thiagofborn/cloudwatch-kinesisfirehose-s3-shell
cd cloudwatch-kinesisfirehose-s3-shell
```
2 - Edit the file subscription.conf with the names and your account id. 

The definitions to create the environment needs to be defined at the file **subscription.conf** as follows:
Be sure that there is no spaces or blank lines assigned to each variable. And add your account id accordingly (**ACCOUNT_ID**), the first line on the file. 
```
ACCOUNT_ID=123456789012
BUCKET_NAME=bucket2cwl2firehose2es
REGION1=eu-west-1
REGION2=eu-west-2
ROLE_NAME_FIREHOSE=Role_cwl2FIREHOSE2es
ROLE_NAME_CWL=Role_2CWL2firehose2es
LOG_GROUP_NAME=LogGroupName_cwl2firehose2es
MY_DELIVERY_STREAM_NAME=Firehose_cwl2firehose2es
DESTINATION_NAME=DestinationName_cwl2firehose2e
```

3 - Run the script 
```
./0_s3_final_destination.sh 
```

## Output 
---
An AWS Kinesis Firehose Delivery Data Stream that receives data from Cloudwatch Logs via subscription filter, and then delivers this data to an S3 bucket. Also, the policies and roles involved in making the actions possible. The table below shows the result based on the default **subscription.conf**. 

Per service the script creates: 
AWS Service Name | Resouce Name | Resouce Type | Quantity
--- | --- | --- | ---
*Kinesis Firehose Delivery Data Stream* | Firehose_cwl2firehose2es | Delivery Stream | 1
*IAM*| Role_cwl2FIREHOSE2es, Role_2CWL2firehose2es | Role |  2
*IAM*| In-line Policy | Permissions-Policy-For-Firehose, Permissions-Policy-For-CWL | 2
*Cloudwatch*| Log-group | LogGroupName_cwl2firehose2es | 1

## Heads up about the Log Group Creation and Put Log subscription
---
It seems the Log Group creation takes a while to get done, so I had to delay the last step (*12_func_put_subscription.sh*) via the *0_s3_final_destination.sh*. 
So, in case you notice the error message: 
```
.                                                                                 .
      "An error occurred (InvalidParameterException) when calling the 
      PutSubscriptionFilter operation: Could not deliver test message to specified 
      Firehose stream. Check if the given Firehose stream is in ACTIVE state."
.                                                                                 .
```

## Deletion of the test environment 
---
The deletion of the test environment reads the same file **subscription.conf** and executes *AWS CLI commands* to delete everything that was created via the script. The script ```13_func_clean_up.sh``` does the "clean" action, deleting the environment. 

---
Please keep in mind this the instructions provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. Feel free to copy and modify as much as you want, however take responsibility of your changes. 

>Notice: If you need some help, open an issue, and we can discuss it together. Feel free to reach out. 





