#!/bin/bash

AMI=ami-0b4f379183e5706b9
SG_ID=sg-0d22010b6339646b9
SUBNET_ID=subnet-04695b2ccf75059d7
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do  
    echo "instance creating is $i"
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --subnet-id $SUBNET_ID
done