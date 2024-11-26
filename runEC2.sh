#!/bin/bash

imageID="ami-0b5673b5f6e8f7fa7" #region: frankfurt eu-central-1
keyName="emi_rsa"    # personal key name
vpcId=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc-stemilia" --query "Vpcs[0].VpcId" --output text)
subnetID=$(aws ec2 describe-subnets --filters "Name=tag:name,Values=my-vpc-stemilia" --query "Subnets[0].SubnetId" --output text)
secGroupId=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=default" "Name=vpc-id,Values=$vpcId" --query "SecurityGroups[0].GroupId" --output text)

aws ec2 run-instances \
    --image-id "$imageID" \
    --instance-type t2.micro \
    --count 1 \
    --subnet-id "$subnetID" \
    --key-name "$keyName" \
    --security-group-ids "$secGroupId" 