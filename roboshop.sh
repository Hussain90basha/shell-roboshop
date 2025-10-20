#!/bin/bash

AMI_ID=ami-"09c813fb71547fc4f" 
SG_ID=sg-"0c2e722c75b408fc5" #replace with your id

for instances in $@
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-0c2e722c75b408fc5 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)

    #Get Private ip
    if [ $instance != "fronted" ]; then
        IP=$(aws ec2 describe-instances --instance-ids i-0b1cc02e2b36c6a74 --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids i-0b1cc02e2b36c6a74 --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
    fi
    echo "$instance: $IP"
done