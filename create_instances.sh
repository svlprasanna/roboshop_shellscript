#!/bin/bash

AMI=ami-0b4f379183e5706b9
SG_ID=sg-0d22010b6339646b9
SUBNET_ID=subnet-04695b2ccf75059d7
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do  
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    
    IP=$(aws ec2 run-instances     --image-id ami-0b4f379183e5706b9     --instance-type t2.micro     --security-group-ids sg-0d22010b6339646b9     --subnet-id subnet-04695b2ccf75059d7     --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query "Instances[0].PrivateIpAddress"     --output text)
    echo "$i: $IP"

#create route 53 record and make sure you record existing records
aws route53 change-resource-record-sets \
  --hosted-zone-id Z0130626BG9FTXQYX8T \
  --change-batch '
  {
    "Comment": "Creating A record for web.example.com",
    "Changes": [{
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "'$i'.'lakshmimohan.shop'",
        "Type": "A",
        "TTL": 1,
        "ResourceRecords": [{
          "Value": "'$IP'"
        }]
      }
    }]
 }'
done
