#!/bin/bash
name="$1"
cidr="$2" # e.g. 10.0.1.0/24

vpcId=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc-stemilia" --query "Vpcs[0].VpcId" --output text
)

aws ec2 create-subnet \
    --vpc-id "$vpcId" \
    --cidr-block "$cidr" \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$name}]"