#!/bin/bash
vpcId=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc-stemilia" --query "Vpcs[0].VpcId" --output text
)

aws ec2 create-subnet \
    --vpc-id "$vpcId" \
    --cidr-block 10.0.1.0/24 \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=my-private-subnet-stemilia}]'