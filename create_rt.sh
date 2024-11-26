#!/bin/bash
vpcId=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc-stemilia" --query "Vpcs[0].VpcId" --output text)

aws ec2 create-route-table \
 --vpc-id "$vpcId" \
 --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=my-public-rt-stemilia}]"